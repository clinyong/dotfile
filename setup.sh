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

echo "==> Installing Zim modules..."
exec zsh -c 'zimfw install'

echo "==> Setup complete! Restart your terminal or run 'exec zsh'"
