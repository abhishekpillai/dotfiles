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

## Sync Scripts

### `sync.sh` - Quick sync from system to repo
```bash
./sync.sh  # Updates repo with latest changes from your system
```

### `sync-advanced.sh` - Bidirectional sync with safety features
```bash
./sync-advanced.sh              # Pull changes from system to repo (default)
./sync-advanced.sh --push       # Push changes from repo to system
./sync-advanced.sh --dry-run    # Preview changes without applying them
```

### `sync-claude.sh` - Claude commands management
```bash
./sync-claude.sh                # Install Claude commands from repo
./sync-claude.sh --pull         # Update repo with your local commands
./sync-claude.sh --dry-run      # Preview what would change
```

## Structure

```
.
├── zsh/                          # Zsh configuration
│   ├── .zshrc                   # Main zsh config (with $HOME paths)
│   ├── .zshenv                  # Environment variables
│   ├── .p10k.zsh                # Powerlevel10k theme config
│   └── .zshrc.local.example     # Template for local overrides
├── git/                          # Git configuration
│   ├── .gitconfig               # Main git config (no email)
│   └── .gitconfig.local.example # Template for email/private settings
├── claude/                       # Claude CLI
│   └── commands/                # Custom Claude commands
│       ├── gc.md               # Git commit with AI-generated messages
│       └── gpr.md              # GitHub PR creation
├── install.sh                    # Installation script
├── sync.sh                       # Quick sync system → repo
├── sync-advanced.sh              # Bidirectional sync with options
├── sync-claude.sh                # Claude commands sync
└── .gitignore                   # Excludes sensitive files
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
- **Claude CLI**: Custom commands for git workflows
  - `/gc` - Create commits with AI-generated messages
  - `/gpr` - Create GitHub PRs with formatted descriptions
- **Sync Tools**: Keep dotfiles up-to-date
  - Quick sync for routine updates
  - Advanced sync with dry-run and push capabilities
  - Dedicated Claude commands sync

## Keeping Your Dotfiles Updated

After making changes to your local configs:

```bash
./sync.sh          # Quick update of repo from your system
# or
./sync-advanced.sh --dry-run  # Preview changes first
./sync-advanced.sh            # Apply changes
```

To sync Claude commands specifically:

```bash
./sync-claude.sh --pull       # Update repo with new commands
./sync-claude.sh              # Install commands on a new machine
```
