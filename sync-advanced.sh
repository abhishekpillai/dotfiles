#!/bin/bash

# Advanced dotfiles sync script with bidirectional sync and safety checks

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Default mode is pull (system -> repo)
MODE="pull"
DRY_RUN=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --push)
            MODE="push"
            shift
            ;;
        --pull)
            MODE="pull"
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  --pull     Update repo from system files (default)"
            echo "  --push     Update system files from repo"
            echo "  --dry-run  Show what would be done without making changes"
            echo "  --help     Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Function to sync files
sync_file() {
    local source="$1"
    local dest="$2"
    local direction="$3"
    
    if [ -f "$source" ]; then
        if [ -f "$dest" ]; then
            if ! cmp -s "$source" "$dest"; then
                if [ "$DRY_RUN" = true ]; then
                    echo -e "${BLUE}[DRY RUN]${NC} Would update: $dest"
                    diff --color=always -u "$dest" "$source" | head -20
                else
                    cp "$source" "$dest"
                    echo -e "${GREEN}✓${NC} Updated: $dest"
                fi
            else
                echo -e "${YELLOW}=${NC} No changes: $(basename "$dest")"
            fi
        else
            if [ "$DRY_RUN" = true ]; then
                echo -e "${BLUE}[DRY RUN]${NC} Would create: $dest"
            else
                mkdir -p "$(dirname "$dest")"
                cp "$source" "$dest"
                echo -e "${GREEN}+${NC} Created: $dest"
            fi
        fi
    else
        echo -e "${RED}✗${NC} Source not found: $source"
    fi
}

# Define file mappings
declare -A FILE_MAP=(
    ["$HOME/.zshrc"]="$DOTFILES_DIR/zsh/.zshrc"
    ["$HOME/.zshenv"]="$DOTFILES_DIR/zsh/.zshenv"
    ["$HOME/.p10k.zsh"]="$DOTFILES_DIR/zsh/.p10k.zsh"
    ["$HOME/.gitconfig"]="$DOTFILES_DIR/git/.gitconfig"
)

echo -e "${BLUE}Dotfiles Sync - Mode: $MODE${NC}"
if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}DRY RUN MODE - No changes will be made${NC}"
fi
echo ""

# Sync based on mode
if [ "$MODE" = "pull" ]; then
    echo -e "${GREEN}Pulling changes from system to repo...${NC}\n"
    
    # Sync regular files
    for system_file in "${!FILE_MAP[@]}"; do
        repo_file="${FILE_MAP[$system_file]}"
        sync_file "$system_file" "$repo_file" "pull"
    done
    
    # Sync Claude commands
    echo -e "\n${GREEN}Syncing Claude commands...${NC}"
    if [ -d "$HOME/.claude/commands" ]; then
        for cmd in "$HOME/.claude/commands"/*.md; do
            if [ -f "$cmd" ]; then
                cmd_name=$(basename "$cmd")
                sync_file "$cmd" "$DOTFILES_DIR/claude/commands/$cmd_name" "pull"
            fi
        done
    fi
    
else # push mode
    echo -e "${GREEN}Pushing changes from repo to system...${NC}\n"
    echo -e "${YELLOW}WARNING: This will overwrite your system files!${NC}"
    
    if [ "$DRY_RUN" = false ]; then
        read -p "Are you sure? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Aborted."
            exit 1
        fi
    fi
    
    # Sync regular files
    for system_file in "${!FILE_MAP[@]}"; do
        repo_file="${FILE_MAP[$system_file]}"
        sync_file "$repo_file" "$system_file" "push"
    done
    
    # Sync Claude commands
    echo -e "\n${GREEN}Syncing Claude commands...${NC}"
    if [ -d "$DOTFILES_DIR/claude/commands" ]; then
        mkdir -p "$HOME/.claude/commands"
        for cmd in "$DOTFILES_DIR/claude/commands"/*.md; do
            if [ -f "$cmd" ]; then
                cmd_name=$(basename "$cmd")
                sync_file "$cmd" "$HOME/.claude/commands/$cmd_name" "push"
            fi
        done
    fi
fi

# Show status if in pull mode and not dry run
if [ "$MODE" = "pull" ] && [ "$DRY_RUN" = false ]; then
    echo -e "\n${GREEN}Git status:${NC}"
    cd "$DOTFILES_DIR"
    git status --short
    
    echo -e "\n${YELLOW}Tips:${NC}"
    echo "- Run 'git diff' to see detailed changes"
    echo "- Run '$0 --dry-run' to preview changes before syncing"
    echo "- Run '$0 --push' to update system files from repo"
fi