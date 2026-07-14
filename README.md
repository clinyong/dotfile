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
mkdir -p ~/bin
ln -sfn ~/dotfiles/pi-web/pi-web ~/bin/pi-web

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
