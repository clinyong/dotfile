# Dotfiles

My zsh configuration using [Zim Framework](https://github.com/zimfw/zimfw) and [Starship](https://starship.rs).

## What's Inside

- **Zim Framework** - Zsh configuration framework with modular plugins
- **Starship** - Cross-platform, customizable prompt
- **z.lua** - Fast directory jump with auto-learning (aliased as `j`)

## Components

| File | Description |
|------|-------------|
| `.zshrc` | Main zsh configuration |
| `.zimrc` | Zim module configuration |
| `setup.sh` | Bootstrap script for new machines |

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
ln -sf ~/dotfiles/.zimrc ~/.zimrc

# Install zim modules
zimfw install
```

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
