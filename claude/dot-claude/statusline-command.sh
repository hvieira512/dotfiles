#!/bin/bash
# Renders the same prompt starship shows in the shell for this directory.
input=$(cat)
dir=$(echo "$input" | jq -r '.workspace.current_dir')

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
export STARSHIP_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/starship"
export GIT_OPTIONAL_LOCKS=0

starship prompt --path "$dir" 2>/dev/null | head -n1
