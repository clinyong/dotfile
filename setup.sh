#!/bin/bash
set -e

DOTFILES_DIR="$HOME/dotfiles"

echo "==> Installing prerequisites..."

# Install Homebrew packages
if command -v brew &> /dev/null; then
    brew install z.lua starship
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
mkdir -p "$HOME/bin"
ln -sfn "$DOTFILES_DIR/pi-web/pi-web" "$HOME/bin/pi-web"

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

echo "==> Installing Zim modules..."
zsh -c 'zimfw install'

echo "==> Setup complete! Restart your terminal or run 'exec zsh'"
