#!/bin/bash
set -e

DOTFILES_DIR="$HOME/dotfiles"

echo "==> Installing prerequisites..."

# Install Homebrew packages
if command -v brew &> /dev/null; then
    brew install z.lua starship tmux lazygit
else
    echo "Homebrew not found. Please install Homebrew first: https://brew.sh"
    exit 1
fi

echo "==> Installing Zim Framework..."
if [[ ! -d "$HOME/.zim" ]]; then
    curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
fi

echo "==> Linking configuration files..."
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.zimrc" "$HOME/.zimrc"
ln -sf "$DOTFILES_DIR/tmux.conf" "$HOME/.tmux.conf"
if [[ "$OSTYPE" == darwin* ]]; then
    GHOSTTY_CONFIG_DIR="$HOME/Library/Application Support/com.mitchellh.ghostty"
else
    GHOSTTY_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty"
fi
mkdir -p "$GHOSTTY_CONFIG_DIR"
ln -sfn "$DOTFILES_DIR/ghostty/config" "$GHOSTTY_CONFIG_DIR/config.ghostty"
mkdir -p "$HOME/bin"
ln -sfn "$DOTFILES_DIR/pi-web/pi-web" "$HOME/bin/pi-web"
ln -sf "$DOTFILES_DIR/bin/android-proxy" "$HOME/bin/android-proxy"

echo "==> Linking pi extensions and themes..."
mkdir -p "$HOME/.pi/agent/extensions" "$HOME/.pi/agent/themes"
ln -sfn "$DOTFILES_DIR/pi/extensions/english-learning-mode.ts" "$HOME/.pi/agent/extensions/english-learning-mode.ts"
ln -sfn "$DOTFILES_DIR/pi/themes/gruvbox-light-hard.json" "$HOME/.pi/agent/themes/gruvbox-light-hard.json"
ln -sfn "$DOTFILES_DIR/pi/themes/gruvbox-dark-medium.json" "$HOME/.pi/agent/themes/gruvbox-dark-medium.json"

# Pi accepts `light-theme/dark-theme` to follow the terminal appearance.
PI_THEME_SETTING="gruvbox-light-hard/gruvbox-dark-medium"
PI_SETTINGS="$HOME/.pi/agent/settings.json"
if [[ -f "$PI_SETTINGS" ]]; then
    if grep -qE '^[[:space:]]*"theme"[[:space:]]*:' "$PI_SETTINGS"; then
        sed -i.bak -E "s|^([[:space:]]*\"theme\"[[:space:]]*:[[:space:]]*\")[^\"]*(\".*)$|\1${PI_THEME_SETTING}\2|" "$PI_SETTINGS"
        rm -f "$PI_SETTINGS.bak"
    else
        echo "Warning: $PI_SETTINGS has no top-level theme setting; set it to $PI_THEME_SETTING manually."
    fi
else
    printf '{\n  "theme": "%s"\n}\n' "$PI_THEME_SETTING" > "$PI_SETTINGS"
fi

echo "==> Installing nvim via mise..."
if command -v mise &>/dev/null; then
    mise use -g neovim@latest
    mise install
else
    echo "mise 未安装,跳过 neovim 安装(请先安装 mise 以管理 nvim)"
fi

echo "==> Linking nvim config..."
mkdir -p "$HOME/.config"
ln -sfn "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

echo "==> Linking lazygit config..."
mkdir -p "$HOME/.config/lazygit"
ln -sfn "$DOTFILES_DIR/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"

echo "==> Installing Zim modules..."
zsh -c 'zimfw install'

echo "==> Setup complete! Restart your terminal or run 'exec zsh'"
