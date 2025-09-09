#!/bin/bash

# Claude sync script - sync Claude commands and settings

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Default mode
MODE="install"
DRY_RUN=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --pull)
            MODE="pull"
            shift
            ;;
        --install)
            MODE="install"
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --help|-h)
            echo "Claude Sync Tool"
            echo ""
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --install   Install commands and settings from repo to ~/.claude (default)"
            echo "  --pull      Pull commands and settings from ~/.claude to repo"
            echo "  --dry-run   Show what would be done without making changes"
            echo "  --help      Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                    # Install all Claude files from repo"
            echo "  $0 --pull             # Update repo with your local Claude files"
            echo "  $0 --dry-run --pull   # Preview what would be pulled"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Run '$0 --help' for usage information"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}Claude Sync${NC}"
echo -e "Mode: ${YELLOW}$MODE${NC}"
if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}DRY RUN MODE - No changes will be made${NC}"
fi
echo ""

# Function to sync a single command
sync_command() {
    local source="$1"
    local dest="$2"
    local cmd_name=$(basename "$source")
    
    if [ -f "$source" ]; then
        # Create destination directory if needed
        if [ "$DRY_RUN" = false ]; then
            mkdir -p "$(dirname "$dest")"
        fi
        
        if [ -f "$dest" ]; then
            if ! cmp -s "$source" "$dest"; then
                if [ "$DRY_RUN" = true ]; then
                    echo -e "${BLUE}[DRY RUN]${NC} Would update: $cmd_name"
                    echo -e "  Changes:"
                    diff --unified=1 "$dest" "$source" | grep '^[+-]' | head -10
                else
                    cp "$source" "$dest"
                    echo -e "${GREEN}✓${NC} Updated: $cmd_name"
                fi
            else
                echo -e "${YELLOW}=${NC} No changes: $cmd_name"
            fi
        else
            if [ "$DRY_RUN" = true ]; then
                echo -e "${BLUE}[DRY RUN]${NC} Would install: $cmd_name"
            else
                cp "$source" "$dest"
                echo -e "${GREEN}+${NC} Installed: $cmd_name"
            fi
        fi
    else
        echo -e "${RED}✗${NC} Not found: $source"
    fi
}

if [ "$MODE" = "install" ]; then
    # Install from repo to system
    echo -e "${GREEN}Installing Claude files from repo...${NC}\n"
    
    # Sync commands
    if [ -d "$DOTFILES_DIR/claude/commands" ]; then
        # Count commands
        cmd_count=$(ls -1 "$DOTFILES_DIR/claude/commands"/*.md 2>/dev/null | wc -l)
        if [ "$cmd_count" -gt 0 ]; then
            echo -e "Found ${BLUE}$cmd_count${NC} command(s) in repo"
            
            # Create target directory
            if [ "$DRY_RUN" = false ]; then
                mkdir -p "$HOME/.claude/commands"
            fi
            
            # Sync each command
            for cmd in "$DOTFILES_DIR/claude/commands"/*.md; do
                if [ -f "$cmd" ]; then
                    cmd_name=$(basename "$cmd")
                    sync_command "$cmd" "$HOME/.claude/commands/$cmd_name"
                fi
            done
            echo ""
        else
            echo -e "${YELLOW}No Claude commands found in repo${NC}"
        fi
    else
        echo -e "${YELLOW}No claude/commands directory found in repo${NC}"
    fi
    
    # Sync settings.json
    if [ -f "$DOTFILES_DIR/claude/settings.json" ]; then
        echo -e "Syncing settings.json..."
        sync_command "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json"
        echo ""
    else
        echo -e "${YELLOW}No settings.json found in repo${NC}"
    fi
    
elif [ "$MODE" = "pull" ]; then
    # Pull from system to repo
    echo -e "${GREEN}Pulling Claude files from system...${NC}\n"
    
    # Pull commands
    if [ -d "$HOME/.claude/commands" ]; then
        # Count commands
        cmd_count=$(ls -1 "$HOME/.claude/commands"/*.md 2>/dev/null | wc -l)
        if [ "$cmd_count" -gt 0 ]; then
            echo -e "Found ${BLUE}$cmd_count${NC} command(s) in system"
            
            # Create target directory
            if [ "$DRY_RUN" = false ]; then
                mkdir -p "$DOTFILES_DIR/claude/commands"
            fi
            
            # Sync each command
            for cmd in "$HOME/.claude/commands"/*.md; do
                if [ -f "$cmd" ]; then
                    cmd_name=$(basename "$cmd")
                    sync_command "$cmd" "$DOTFILES_DIR/claude/commands/$cmd_name"
                fi
            done
            echo ""
        else
            echo -e "${YELLOW}No Claude commands found in ~/.claude/commands${NC}"
        fi
    else
        echo -e "${YELLOW}No ~/.claude/commands directory found${NC}"
    fi
    
    # Pull settings.json
    if [ -f "$HOME/.claude/settings.json" ]; then
        echo -e "Syncing settings.json..."
        sync_command "$HOME/.claude/settings.json" "$DOTFILES_DIR/claude/settings.json"
        echo ""
    else
        echo -e "${YELLOW}No settings.json found in ~/.claude/${NC}"
    fi
    
    # Show git status if not dry run
    if [ "$DRY_RUN" = false ]; then
        echo -e "${GREEN}Git status:${NC}"
        cd "$DOTFILES_DIR"
        git status --short claude/
    fi
fi

echo -e "\n${GREEN}Done!${NC}"

# Show available commands
if [ "$MODE" = "install" ] && [ "$DRY_RUN" = false ]; then
    echo -e "\n${BLUE}Available Claude commands:${NC}"
    for cmd in "$HOME/.claude/commands"/*.md; do
        if [ -f "$cmd" ]; then
            cmd_name=$(basename "$cmd" .md)
            desc=$(grep -m1 "^description:" "$cmd" 2>/dev/null | sed 's/description: *//')
            if [ -n "$desc" ]; then
                echo -e "  ${GREEN}/$cmd_name${NC} - $desc"
            else
                echo -e "  ${GREEN}/$cmd_name${NC}"
            fi
        fi
    done
fi