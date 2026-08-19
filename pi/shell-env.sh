# POSIX-compatible shell environment bootstrap for Pi's non-interactive bash.
# Keep this file free of interactive-only shell setup, aliases, prompts, bindkey, zim, starship, etc.

path_prepend() {
  [ -n "$1" ] || return 0
  [ -d "$1" ] || return 0
  case ":$PATH:" in
    *:"$1":*) ;;
    *) PATH="$1${PATH:+:$PATH}" ;;
  esac
}

# Homebrew: support both Apple Silicon and Intel/macOS default locations.
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# User toolchains and local binaries.
export BUN_INSTALL="${BUN_INSTALL:-$HOME/.bun}"
path_prepend "$BUN_INSTALL/bin"
path_prepend "$HOME/.cargo/bin"
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/.opencode/bin"

export PATH
