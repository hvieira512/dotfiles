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
[ -d ~/.config/tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
~/.config/tmux/plugins/tpm/bin/install_plugins
