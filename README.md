# dotfiles

My personal dotfiles for macOS with zsh, git, and other developer tools.

## Features

- 🔐 Privacy-focused structure with local overrides for sensitive data
- 🚀 Oh My Zsh with Powerlevel10k theme
- 📦 Organized directory structure for different tools
- 🔧 Easy installation with backup support

## Installation

```bash
git clone https://github.com/abhishekpillai/dotfiles.git ~/Development/dotfiles
cd ~/Development/dotfiles
./install.sh
```

## Structure

```
.
├── zsh/                    # Zsh configuration
│   ├── .zshrc             # Main zsh config (with $HOME paths)
│   ├── .zshenv            # Environment variables
│   ├── .p10k.zsh          # Powerlevel10k theme config
│   └── .zshrc.local.example  # Template for local overrides
├── git/                    # Git configuration
│   ├── .gitconfig         # Main git config (no email)
│   └── .gitconfig.local.example  # Template for email/private settings
├── install.sh             # Installation script
└── .gitignore            # Excludes sensitive files

```

## Privacy

This dotfiles setup keeps sensitive information private:

- **Email addresses** are stored in `~/.gitconfig.local` (not tracked)
- **Machine-specific paths** use `$HOME` instead of hardcoded usernames
- **Local overrides** via `.local` files for custom settings per machine

## Customization

After installation, create your local config files:

1. **Git email**: Copy `git/.gitconfig.local.example` to `~/.gitconfig.local` and add your email
2. **Machine-specific zsh**: Copy `zsh/.zshrc.local.example` to `~/.zshrc.local` for custom aliases/paths

## What's Included

- **Zsh**: Oh My Zsh, Powerlevel10k, syntax highlighting, autosuggestions
- **Git**: Sensible defaults, color output
- **Package managers**: Homebrew, rbenv, pnpm paths
- **Tools**: Claude CLI alias
