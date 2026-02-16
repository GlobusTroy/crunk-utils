#!/bin/bash

# Create soft links from all AGENTS.md files to CLAUDE.md in the same directories
# Usage: ./link_agents_to_claude.sh [directory]
# If no directory specified, uses current directory
# Recursively finds all AGENTS.md files and creates corresponding CLAUDE.md links

DIRECTORY="${1:-.}"
LINK_COUNT=0

# Find all AGENTS.md files recursively
while IFS= read -r agents_file; do
    dir_path=$(dirname "$agents_file")
    claude_file="$dir_path/CLAUDE.md"
    
    # Create soft link (force overwrite if exists)
    ln -sf "AGENTS.md" "$claude_file"
    
    echo "Linked: $claude_file -> $agents_file"
    ((LINK_COUNT++))
done < <(find "$DIRECTORY" -name "AGENTS.md" -type f)

echo "Done. Linked $LINK_COUNT AGENTS.md files to CLAUDE.md"
