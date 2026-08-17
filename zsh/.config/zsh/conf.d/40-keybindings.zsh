# Keybindings. Loaded after 30-plugins.zsh so the widgets these bind to exist.

# vi mode, to match nvim and the vim-style pane bindings in tmux.conf.
bindkey -v

# zsh waits KEYTIMEOUT hundredths of a second after ESC to see whether an escape
# sequence follows. The default 0.4s makes leaving insert mode feel broken.
export KEYTIMEOUT=1

# --- cursor shape -----------------------------------------------------------
# Beam in insert, block in normal — otherwise there's no way to tell which mode
# you're in. Driven from precmd rather than a zle-line-init widget, which would
# have to be defined before zsh-autosuggestions to get wrapped correctly.
_vi_cursor_shape() {
  case ${KEYMAP:-viins} in
    vicmd) print -n '\e[2 q' ;;   # steady block
    *)     print -n '\e[6 q' ;;   # steady beam
  esac
}
zle -N zle-keymap-select _vi_cursor_shape

# Every new prompt starts in insert mode, and anything full-screen you just
# exited (nvim, lazygit) may have left the cursor as a block.
_vi_cursor_beam() { print -n '\e[6 q' }
autoload -Uz add-zsh-hook
add-zsh-hook precmd _vi_cursor_beam

# --- history ----------------------------------------------------------------
# Up/Down filter history to lines starting with what's already typed, rather
# than walking every command blindly.
bindkey -M viins '^[[A' history-substring-search-up
bindkey -M viins '^[[B' history-substring-search-down
bindkey -M viins '^P'   history-substring-search-up
bindkey -M viins '^N'   history-substring-search-down
bindkey -M vicmd '^[[A' history-substring-search-up
bindkey -M vicmd '^[[B' history-substring-search-down
# j/k stay as vi movement in normal mode — they're needed for multi-line edits.

# --- edit the command line in nvim -----------------------------------------
# For anything long enough that editing it inline is painful.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M viins '^X^E' edit-command-line
bindkey -M vicmd 'v'    edit-command-line   # matches bash's vi mode

# --- emacs motions worth keeping in vi mode ---------------------------------
# These are the ones muscle memory reaches for mid-line, where dropping to
# normal mode first isn't worth it.
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^K' kill-line
bindkey -M viins '^U' backward-kill-line
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^Y' yank
bindkey -M viins '^[.' insert-last-word          # alt-. pulls the last arg of the previous command

# zsh's vi mode refuses to backspace past where insert mode began, which is
# almost never what you want at a prompt.
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char

# Accept the whole autosuggestion without leaving the home row.
bindkey -M viins '^F' autosuggest-accept

# --- completion menu --------------------------------------------------------
# Inside the menu, hjkl navigates and ESC leaves without accepting.
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect '^[' send-break

# --- misc -------------------------------------------------------------------
# Surround-style text objects in normal mode: ci", da(, and friends.
autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed
for km in viopp visual; do
  bindkey -M $km -- '-' vi-up-line-or-history
  for c in {a,i}${(s..)^:-\'\"\`\|,./:;=+@}; do
    bindkey -M $km $c select-quoted
  done
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $km $c select-bracketed
  done
done
unset km c
