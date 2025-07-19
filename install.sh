#!/bin/bash

# Dotfiles installation script

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Installing dotfiles from $DOTFILES_DIR..."

# Create backup directory
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    
    # If target exists and is not a symlink, back it up
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "Backing up existing $target to $BACKUP_DIR"
        cp -r "$target" "$BACKUP_DIR/"
    fi
    
    # Remove existing file/symlink
    rm -rf "$target"
    
    # Create symlink
    ln -s "$source" "$target"
    echo "Created symlink: $target -> $source"
}

# Zsh configurations
create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/zsh/.zshenv" "$HOME/.zshenv"
create_symlink "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"

# Git configuration
create_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

# Claude commands
if [ -d "$DOTFILES_DIR/claude/commands" ]; then
    mkdir -p "$HOME/.claude/commands"
    for cmd in "$DOTFILES_DIR/claude/commands"/*.md; do
        if [ -f "$cmd" ]; then
            cmd_name=$(basename "$cmd")
            create_symlink "$cmd" "$HOME/.claude/commands/$cmd_name"
        fi
    done
fi

# Create local config files from examples if they don't exist
if [ ! -f "$HOME/.gitconfig.local" ] && [ -f "$DOTFILES_DIR/git/.gitconfig.local.example" ]; then
    cp "$DOTFILES_DIR/git/.gitconfig.local.example" "$HOME/.gitconfig.local"
    echo "Created ~/.gitconfig.local from example - please update with your email!"
fi

if [ ! -f "$HOME/.zshrc.local" ] && [ -f "$DOTFILES_DIR/zsh/.zshrc.local.example" ]; then
    cp "$DOTFILES_DIR/zsh/.zshrc.local.example" "$HOME/.zshrc.local"
    echo "Created ~/.zshrc.local from example"
fi

echo "Dotfiles installation complete!"
echo "Backup of existing files saved to: $BACKUP_DIR"
echo ""
echo "IMPORTANT: Don't forget to update ~/.gitconfig.local with your email address!"