import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

type CorrectionLevel = "light" | "detailed" | "off";

const levels: readonly CorrectionLevel[] = ["light", "detailed", "off"];

export default function englishLearningMode(pi: ExtensionAPI) {
	let enabled = false;
	let correctionLevel: CorrectionLevel = "light";

	const updateStatus = (ctx: { ui: { setStatus(key: string, value?: string): void } }) => {
		ctx.ui.setStatus(
			"english-learning-mode",
			enabled ? `English: ${correctionLevel} corrections` : undefined,
		);
	};

	pi.registerCommand("english", {
		description: "English learning mode: /english on|off|toggle|light|detailed|off-corrections|status",
		handler: async (args, ctx) => {
			const action = args.trim().toLowerCase();

			if (action === "" || action === "toggle") {
				enabled = !enabled;
			} else if (action === "on") {
				enabled = true;
			} else if (action === "off") {
				enabled = false;
			} else if (action === "light" || action === "detailed") {
				enabled = true;
				correctionLevel = action;
			} else if (action === "off-corrections") {
				enabled = true;
				correctionLevel = "off";
			} else if (action === "status") {
				ctx.ui.notify(
					enabled
						? `English learning mode is on (${correctionLevel} corrections).`
						: "English learning mode is off.",
					"info",
				);
				return;
			} else {
				ctx.ui.notify(
					"Usage: /english on|off|toggle|light|detailed|off-corrections|status",
					"warning",
				);
				return;
			}

			updateStatus(ctx);
			ctx.ui.notify(
				enabled
					? `English learning mode enabled (${correctionLevel} corrections).`
					: "English learning mode disabled.",
				"info",
			);
		},
	});

	pi.on("before_agent_start", (event) => {
		if (!enabled) return;

		const correctionInstruction = correctionLevel === "off"
			? "Do not add unsolicited language corrections."
			: correctionLevel === "light"
				? "After your main answer, add a short **Quick corrections** section only when there are one or two meaningful, teachable errors. Show a natural rewrite, not every tiny issue."
				: "After your main answer, add a **Quick corrections** section. Identify important grammar, wording, or naturalness improvements concisely, explain them briefly, and show a natural rewrite.";

		return {
			systemPrompt: `${event.systemPrompt}\n\nENGLISH LEARNING MODE IS ENABLED.\n- Use English by default for conversation and explanations.\n- Help the user express themselves naturally and encourage them without being patronizing.\n- Preserve the user's intended meaning; answer their actual request first.\n- Do not correct code, commands, proper names, quotations, or text the user explicitly asks you to preserve.\n- If the user explicitly asks for another language, translation, or a different correction style, follow that request.\n- ${correctionInstruction}`,
		};
	});
}
