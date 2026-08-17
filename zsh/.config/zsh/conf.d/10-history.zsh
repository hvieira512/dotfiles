# History. The zsh defaults are 2000 in memory / 1000 on disk with no dedup and
# no sharing, which loses commands constantly across tmux panes.

export HISTFILE="$XDG_STATE_HOME/zsh/history"
export HISTSIZE=100000   # entries kept in memory for this session
export SAVEHIST=100000   # entries written out to HISTFILE
mkdir -p "${HISTFILE:h}"

setopt extended_history       # store start timestamp and duration per entry
setopt inc_append_history     # append as you go instead of only at shell exit
setopt share_history          # commands from one tmux pane show up in the others
setopt hist_ignore_dups       # a command identical to the previous one isn't stored
setopt hist_ignore_all_dups   # ...and a repeat elsewhere replaces the older copy
setopt hist_expire_dups_first # when trimming to SAVEHIST, drop duplicates first
setopt hist_find_no_dups      # searching never shows the same line twice in a row
setopt hist_ignore_space      # a leading space keeps a command out of history
setopt hist_reduce_blanks     # normalise whitespace before storing
setopt hist_verify            # !! expands onto the line for review, not straight to run
setopt hist_no_store          # don't record `history` calls themselves

# Commands too short or too routine to be worth remembering — they only get in
# the way of a substring search.
export HISTORY_IGNORE='(ls|ll|la|cd|cd ..|pwd|exit|clear|z|history)'
