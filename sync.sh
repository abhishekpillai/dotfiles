#!/bin/bash

# Dotfiles sync script - updates repo with latest from system files

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Syncing dotfiles from system to $DOTFILES_DIR..."

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Get current username for path sanitization
CURRENT_USER="$USER"
HOME_PATH="/Users/$CURRENT_USER"

# Function to sync file from system to repo
sync_file() {
    local system_file="$1"
    local repo_file="$2"

    if [ -f "$system_file" ]; then
        if [ -f "$repo_file" ]; then
            # Check if files differ
            if ! cmp -s "$system_file" "$repo_file"; then
                cp "$system_file" "$repo_file"
                echo -e "${GREEN}✓${NC} Updated: $repo_file"
            else
                echo -e "${YELLOW}=${NC} No changes: $repo_file"
            fi
        else
            # File doesn't exist in repo yet
            cp "$system_file" "$repo_file"
            echo -e "${GREEN}+${NC} Added: $repo_file"
        fi
    else
        echo -e "${RED}✗${NC} Not found: $system_file"
    fi
}

# Sanitize zsh files: replace hardcoded home path with $HOME
sanitize_zsh() {
    local file="$1"
    if [ -f "$file" ]; then
        # Replace hardcoded home path with $HOME
        sed -i '' "s|$HOME_PATH|\$HOME|g" "$file"

        # Ensure .zshrc.local sourcing is present at end of .zshrc
        if [[ "$file" == *".zshrc" ]] && ! grep -q "source ~/.zshrc.local" "$file"; then
            echo "" >> "$file"
            echo "# Load local machine-specific configurations if they exist" >> "$file"
            echo '[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local' >> "$file"
        fi

        echo -e "${GREEN}✓${NC} Sanitized: $file"
    fi
}

# Sanitize gitconfig: remove email and ensure .gitconfig.local include
sanitize_gitconfig() {
    local file="$1"
    if [ -f "$file" ]; then
        # Remove email line
        sed -i '' '/^[[:space:]]*email[[:space:]]*=/d' "$file"

        # Add comment about email location if [user] section exists
        if grep -q "^\[user\]" "$file" && ! grep -q "Email should be set" "$file"; then
            sed -i '' 's/^\[user\]/[user]\
	# Email should be set in ~\/.gitconfig.local/' "$file"
        fi

        # Ensure include for .gitconfig.local is at the top
        if ! grep -q "path = ~/.gitconfig.local" "$file"; then
            local tmp_file=$(mktemp)
            echo "[include]" > "$tmp_file"
            echo "	path = ~/.gitconfig.local" >> "$tmp_file"
            echo "" >> "$tmp_file"
            cat "$file" >> "$tmp_file"
            mv "$tmp_file" "$file"
        fi

        echo -e "${GREEN}✓${NC} Sanitized: $file"
    fi
}

# Sync zsh files
echo -e "\n${GREEN}Syncing zsh configs...${NC}"
sync_file "$HOME/.zshrc" "$DOTFILES_DIR/zsh/.zshrc"
sync_file "$HOME/.zshenv" "$DOTFILES_DIR/zsh/.zshenv"
sync_file "$HOME/.p10k.zsh" "$DOTFILES_DIR/zsh/.p10k.zsh"

# Sanitize zsh files (replace hardcoded paths with $HOME)
echo -e "\n${GREEN}Sanitizing zsh configs...${NC}"
sanitize_zsh "$DOTFILES_DIR/zsh/.zshrc"
sanitize_zsh "$DOTFILES_DIR/zsh/.zshenv"

# Sync git files
echo -e "\n${GREEN}Syncing git configs...${NC}"
sync_file "$HOME/.gitconfig" "$DOTFILES_DIR/git/.gitconfig"

# Sanitize git config (remove email, add .gitconfig.local include)
echo -e "\n${GREEN}Sanitizing git config...${NC}"
sanitize_gitconfig "$DOTFILES_DIR/git/.gitconfig"

# Sync Claude commands
echo -e "\n${GREEN}Syncing Claude commands...${NC}"
if [ -d "$HOME/.claude/commands" ]; then
    for cmd in "$HOME/.claude/commands"/*.md; do
        if [ -f "$cmd" ]; then
            cmd_name=$(basename "$cmd")
            sync_file "$cmd" "$DOTFILES_DIR/claude/commands/$cmd_name"
        fi
    done
else
    echo -e "${YELLOW}No Claude commands directory found${NC}"
fi

# Show git status
echo -e "\n${GREEN}Git status:${NC}"
cd "$DOTFILES_DIR"
git status --short

# Offer to show diff
echo -e "\n${YELLOW}Run 'git diff' to see detailed changes${NC}"