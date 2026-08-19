import { createHash } from "node:crypto";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const ANKI_URL = process.env.ANKI_CONNECT_URL ?? "http://127.0.0.1:8765";
const OPENAI_TTS_URL = "https://api.openai.com/v1/audio/speech";
const OPENAI_CHAT_URL = "https://api.openai.com/v1/chat/completions";
const SPEAKING_DECK = "English::Speaking";
const TYPING_DECK = "English::Typing";

type AnkiResponse<T> = { result: T; error: string | null };
type AnkiNote = {
	deckName: string;
	modelName: string;
	fields: Record<string, string>;
	tags: string[];
	options: { allowDuplicate: false };
};

function escapeHtml(text: string) {
	return text.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
}

function parseInput(input: string) {
	const separator = input.indexOf("|");
	if (separator === -1) return { sentence: input.trim(), meaning: "" };
	return {
		sentence: input.slice(0, separator).trim(),
		meaning: input.slice(separator + 1).trim(),
	};
}

async function requestAnki<T>(action: string, params: Record<string, unknown>): Promise<T> {
	const response = await fetch(ANKI_URL, {
		method: "POST",
		headers: { "Content-Type": "application/json" },
		body: JSON.stringify({ action, version: 6, params }),
	});
	if (!response.ok) throw new Error(`AnkiConnect returned HTTP ${response.status}.`);
	const payload = (await response.json()) as AnkiResponse<T>;
	if (payload.error) throw new Error(`AnkiConnect ${action} failed: ${payload.error}`);
	return payload.result;
}

async function translateToChinese(sentence: string, apiKey: string): Promise<string> {
	const response = await fetch(OPENAI_CHAT_URL, {
		method: "POST",
		headers: {
			Authorization: `Bearer ${apiKey}`,
			"Content-Type": "application/json",
		},
		body: JSON.stringify({
			model: "gpt-4o-mini",
			messages: [
				{
					role: "system",
					content: "Translate the given English sentence into concise, natural Simplified Chinese for an English speaking-recall Anki card. Return only the Chinese translation. Preserve the meaning and tone; do not explain or add quotation marks.",
				},
				{ role: "user", content: sentence },
			],
			temperature: 0.2,
		}),
	});
	if (!response.ok) {
		const detail = await response.text();
		throw new Error(`OpenAI translation failed (HTTP ${response.status}): ${detail}`);
	}
	const payload = (await response.json()) as { choices?: Array<{ message?: { content?: string } }> };
	const translation = payload.choices?.[0]?.message?.content?.trim();
	if (!translation) throw new Error("OpenAI translation returned no text.");
	return translation;
}

async function synthesize(sentence: string, apiKey: string): Promise<Buffer> {
	const response = await fetch(OPENAI_TTS_URL, {
		method: "POST",
		headers: {
			Authorization: `Bearer ${apiKey}`,
			"Content-Type": "application/json",
		},
		body: JSON.stringify({
			model: "gpt-4o-mini-tts",
			voice: "coral",
			input: sentence,
			instructions: "Speak clearly and naturally at a moderate pace for an English learner.",
			response_format: "mp3",
		}),
	});
	if (!response.ok) {
		const detail = await response.text();
		throw new Error(`OpenAI TTS failed (HTTP ${response.status}): ${detail}`);
	}
	return Buffer.from(await response.arrayBuffer());
}

export default function ankiEnglish(pi: ExtensionAPI) {
	pi.registerCommand("anki", {
		description: "Create English Speaking + Typing cards: /anki English sentence (optional: | Chinese meaning)",
		handler: async (args, ctx) => {
			let input = args.trim();
			if (!input) {
				const clipboard = await pi.exec("pbpaste", []);
				input = clipboard.code === 0 ? clipboard.stdout.trim() : "";
			}

			let { sentence, meaning } = parseInput(input);
			if (!sentence) {
				sentence = (await ctx.ui.input("English sentence", "Paste or type one complete English sentence"))?.trim() ?? "";
			}
			if (!sentence) {
				ctx.ui.notify("Cancelled: an English sentence is required.", "warning");
				return;
			}

			const apiKey = process.env.MY_OPEN_AI ?? process.env.OPENAI_API_KEY;
			if (!apiKey) {
				ctx.ui.notify("MY_OPEN_AI or OPENAI_API_KEY is not set in Pi's environment.", "error");
				return;
			}

			try {
				if (!meaning) {
					ctx.ui.notify("Generating a Chinese meaning…", "info");
					meaning = await translateToChinese(sentence, apiKey);
				}

				await requestAnki<number>("version", {});
				const deckNames = await requestAnki<string[]>("deckNames", {});
				for (const deck of [SPEAKING_DECK, TYPING_DECK]) {
					if (!deckNames.includes(deck)) throw new Error(`Missing Anki deck: ${deck}`);
				}

				const basicFields = await requestAnki<string[]>("modelFieldNames", { modelName: "Basic" });
				const typingFields = await requestAnki<string[]>("modelFieldNames", { modelName: "Basic (type in the answer)" });
				if (basicFields.join(",") !== "Front,Back" || typingFields.join(",") !== "Front,Back") {
					throw new Error("The required Anki models must have exactly Front and Back fields.");
				}

				ctx.ui.notify("Generating OpenAI TTS audio…", "info");
				const audio = await synthesize(sentence, apiKey);
				const filename = `english-${createHash("sha256").update(audio).digest("hex").slice(0, 16)}.mp3`;
				const safeSentence = escapeHtml(sentence);
				const safeMeaning = escapeHtml(meaning);
				const notes: AnkiNote[] = [
					{
						deckName: SPEAKING_DECK,
						modelName: "Basic",
						fields: {
							Front: `请用英语说：${safeMeaning}`,
							Back: `${safeSentence}<br><br>[sound:${filename}]`,
						},
						tags: ["english", "sentence-mining", "speaking"],
						options: { allowDuplicate: false },
					},
					{
						deckName: TYPING_DECK,
						modelName: "Basic (type in the answer)",
						fields: {
							Front: `打英语：${safeMeaning}`,
							Back: sentence,
						},
						tags: ["english", "sentence-mining", "typing"],
						options: { allowDuplicate: false },
					},
				];

				const checks = await requestAnki<Array<{ canAdd: boolean; error?: string | null }>>(
					"canAddNotesWithErrorDetail",
					{ notes },
				);
				if (checks.length !== notes.length || checks.some((check) => !check.canAdd)) {
					throw new Error(`Duplicate or invalid card: ${checks.map((check) => check.error ?? "unknown error").join("; ")}`);
				}

				await requestAnki<string>("storeMediaFile", { filename, data: audio.toString("base64") });
				const noteIds: number[] = [];
				for (const note of notes) {
					const noteId = await requestAnki<number>("addNote", { note });
					const info = await requestAnki<Array<{ noteId: number; modelName: string; fields: Record<string, { value: string }>; cards: number[] }>>(
						"notesInfo",
						{ notes: [noteId] },
					);
					if (info[0]?.noteId !== noteId || info[0]?.modelName !== note.modelName || info[0]?.fields.Front?.value !== note.fields.Front) {
						throw new Error(`Created note ${noteId}, but verification did not match.`);
					}
					const cards = await requestAnki<Array<{ deckName: string }>>("cardsInfo", { cards: info[0].cards });
					if (cards.some((card) => card.deckName !== note.deckName)) {
						throw new Error(`Created note ${noteId}, but its card is in the wrong deck.`);
					}
					noteIds.push(noteId);
				}

				ctx.ui.notify(`Created and verified Speaking + Typing cards (notes ${noteIds.join(", ")}).`, "info");
			} catch (error) {
				ctx.ui.notify(error instanceof Error ? error.message : String(error), "error");
			}
		},
	});
}
