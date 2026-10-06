#!/bin/bash
# Renders the same prompt starship shows in the shell for this directory.
input=$(cat)
dir=$(echo "$input" | jq -r '.workspace.current_dir')

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
export STARSHIP_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/starship"
export GIT_OPTIONAL_LOCKS=0
# Inherited from the shell that launched Claude, it makes starship wrap colours
# in zsh's %{ %}, which the status line prints literally.
unset STARSHIP_SHELL

# add_newline is on, so the prompt is the first non-empty line, not the first.
starship prompt --path "$dir" 2>/dev/null | grep -m1 .
