#!/bin/sh
# New machine: brew, packages, stow, and the one-off cache builds. Safe to re-run.
set -eu
cd "$(dirname "$0")"

command -v brew >/dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle --file=Brewfile

# ~/.gitconfig overrides ~/.config/git/config
[ -f ~/.gitconfig ] && mv ~/.gitconfig ~/.gitconfig.bak

for pkg in */; do stow "${pkg%/}"; done

bat cache --build
[ -f ~/.config/btop/btop.conf ] || printf 'color_theme = "rose-pine-moon"\ntheme_background = False\n' > ~/.config/btop/btop.conf
[ -d ~/.local/share/vim-herdr-navigation ] || git clone https://github.com/paulbkim-dev/vim-herdr-navigation ~/.local/share/vim-herdr-navigation
herdr plugin link ~/.local/share/vim-herdr-navigation >/dev/null
herdr plugin install ChmaraX/herdr-nvim --yes >/dev/null

# Pokémon sprite, not redistributed in this public repo. 55-fastfetch.zsh plays
# the frames over the kitty protocol. 3x keeps the edges crisp enough while
# herdr re-sends each frame as raw RGBA; 8x made it ghost.
ff=~/.local/share/fastfetch
[ -f $ff/charizard.gif ] || curl -fsSL --create-dirs -o $ff/charizard.gif https://img.pokemondb.net/sprites/black-white/anim/shiny/charizard.gif
[ -d $ff/charizard ] || { mkdir $ff/charizard && magick $ff/charizard.gif -coalesce +repage -sample 300% $ff/charizard/%03d.png; }
