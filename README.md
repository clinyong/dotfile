# Dotfiles

My zsh configuration using [Zim Framework](https://github.com/zimfw/zimfw) and [Starship](https://starship.rs).

## What's Inside

- **Zim Framework** - Zsh configuration framework with modular plugins
- **Starship** - Cross-platform, customizable prompt
- **z.lua** - Fast directory jump with auto-learning (aliased as `j`)

## Components

| File | Description |
|------|-------------|
| `.zshrc` | Main zsh configuration (interactive shells) |
| `.zprofile` | Login shell config — PATH and env for login shells |
| `.zimrc` | Zim module configuration |
| `setup.sh` | Bootstrap script for new machines |
| `pi-web/` | Local pi-web wrapper, service scripts, and integration test |
| `git/aliases.sh` | Git aliases and helper functions (gss/gp/gco/...) |
| `ghostty/config` | Ghostty configuration (Gruvbox Light Hard / Dark) |
| `nvim/` | Neovim configuration (lazy.nvim, Gruvbox Light Hard / Dark) |
| `lazygit/config.yml` | LazyGit configuration using the Ghostty Gruvbox palette |
| `pi/themes/` | Pi Gruvbox Light Hard / Dark Medium themes |

## Quick Setup on New Machine

```bash
# Clone dotfiles
git clone https://github.com/your-username/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Run setup (requires Homebrew)
chmod +x setup.sh
./setup.sh
```

## Manual Installation

If you prefer to install manually:

### Prerequisites

- Zsh 5.0+
- Homebrew

### Install Components

```bash
# Install Zim
curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh

# Install Starship
curl -fsSL https://raw.githubusercontent.com/starship/starship/master/install/install.sh | sh -s -- --yes

# Install z.lua
brew install z.lua

# Link configs
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.zprofile ~/.zprofile
ln -sf ~/dotfiles/.zimrc ~/.zimrc
mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
ln -sfn ~/dotfiles/ghostty/config "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
mkdir -p ~/bin
ln -sfn ~/dotfiles/pi-web/pi-web ~/bin/pi-web

# Link Pi themes (use Automatic in /settings, or set this in ~/.pi/agent/settings.json)
mkdir -p ~/.pi/agent/themes
ln -sfn ~/dotfiles/pi/themes/gruvbox-light-hard.json ~/.pi/agent/themes/gruvbox-light-hard.json
ln -sfn ~/dotfiles/pi/themes/gruvbox-dark-medium.json ~/.pi/agent/themes/gruvbox-dark-medium.json
# "theme": "gruvbox-light-hard/gruvbox-dark-medium"

# Install nvim via mise (assumes mise is already installed)
mise use -g neovim@latest && mise install
ln -sfn ~/dotfiles/nvim ~/.config/nvim

# Link LazyGit config (LG_CONFIG_FILE is exported by .zshrc)
mkdir -p ~/.config/lazygit
ln -sfn ~/dotfiles/lazygit/config.yml ~/.config/lazygit/config.yml

# Install zim modules
zimfw install
```

## Per-machine local config (not in this repo)

Some things intentionally stay **out** of this repo and live on each machine:

- `~/.local.d/init.sh` — sourced by `.zshrc` if present. Put machine-specific
  extras here (OrbStack/kiro integration, absolute-path aliases, etc.).
- `~/.zshenv` — secrets and global `export`s, loaded by all zsh invocations
  (including `zsh -lc`). Keep it to pure `export` only.

Do **not** commit secrets to this repo.

## Usage

| Command | Description |
|---------|-------------|
| `j <dir>` | Jump to frequently used directory |
| `j foo` | Fuzzy jump to directory matching "foo" |
| `j -i foo` | Interactive directory selection |
| `zimfw update` | Update all Zim modules |
| `zimfw install` | Install new modules |
| `starship init zsh` | Initializes Starship prompt |

## Customization

### Adding Zim Modules

Edit `~/.zimrc`:

```bash
zmodule module-name
```

Then run `zimfw install`.

### Starship Configuration

Create or edit `~/.config/starship.toml`. See [Starship docs](https://starship.rs/config/) for options.
