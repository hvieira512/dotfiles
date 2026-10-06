# Aliases and small functions.

# --- listing ----------------------------------------------------------------
# eza replaces ls: --git annotates each entry with its working-tree status, and
# the icons come from the Nerd Font ghostty is already loading.
alias ls='eza --icons --group-directories-first'
alias ll='eza --icons --group-directories-first --long --git --header'
alias la='eza --icons --group-directories-first --long --git --header --all'
alias lt='eza --icons --tree --level=2 --git-ignore'
alias ltt='eza --icons --tree --level=4 --git-ignore'

# bat degrades to plain cat when stdout isn't a terminal, so pipes and
# redirections behave exactly as before.
alias cat='bat --paging=never'
alias catp='bat --paging=never --style=plain'   # no line numbers, for copy-paste

# --- editor -----------------------------------------------------------------
alias v='nvim'
alias vi='nvim'
alias vim='nvim'

# --- git --------------------------------------------------------------------
# Note: no `gs` — that's ghostscript's binary, which is installed.
alias g='git'
alias gst='git status --short --branch'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit --message'
alias gca='git commit --amend'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline --graph --decorate --max-count=20'
alias gla='git log --oneline --graph --decorate --all'
alias gp='git push'
alias gpf='git push --force-with-lease'   # never bare --force
alias gpl='git pull --rebase'
alias gsw='git switch'
alias gswc='git switch --create'
alias gb='git branch'
alias grs='git restore'
alias lg='lazygit'

# --- tmux -------------------------------------------------------------------
alias t='tmux'
alias ta='tmux attach || tmux new'
alias tl='tmux list-sessions'

# --- dotfiles and brew ------------------------------------------------------
# $ZDOTDIR is a stow symlink into the repo; :A resolves it, :h:h:h is the root.
export DOTFILES="${${ZDOTDIR:A}:h:h:h}"
alias dot='cd $DOTFILES'
alias zc='$EDITOR $ZDOTDIR'
alias reload='exec zsh'
alias brewup='brew update && brew upgrade && brew cleanup'
# Installed here but not in the Brewfile. Lists only, removes nothing.
alias brewdrift='brew bundle cleanup --file="$DOTFILES/Brewfile"'

# --- claude code --------------------------------------------------------------
# Always start with the Claude in Chrome integration on, so Claude can drive the
# Brave window that's already open — read the page, click, measure — without the
# browser needing anything special. The extension is already installed.
#
# It has to be an alias because `--chrome` is a startup option: a session begun
# without it can't turn it on later. The alternative was launching Brave with
# `--remote-debugging-port=9222` for the chrome-devtools MCP, which only takes
# effect at browser startup and so meant quitting the browser every time.
#
# zsh doesn't re-expand an alias over its own name, so this doesn't recurse, and
# `claude --no-chrome` still opts out — the later flag wins.
alias claude='claude --chrome'

# --- misc -------------------------------------------------------------------
alias path='print -l $path'
alias ports='lsof -iTCP -sTCP:LISTEN -P -n'
alias ip='curl -s https://ifconfig.me && echo'
alias df='df -h'
alias du='dust'
alias top='btop'
alias help='tldr'

# --- global aliases ---------------------------------------------------------
# A zsh feature bash doesn't have: these expand anywhere on the line, not just
# in command position. `cat foo.json J .name` works.
alias -g G='| rg'
alias -g L='| less'
alias -g J='| jq'
alias -g H='| head -50'
alias -g T='| tail -50'
alias -g NE='2>/dev/null'
alias -g NUL='>/dev/null 2>&1'
alias -g C='| pbcopy'

# --- functions --------------------------------------------------------------

# mkdir and cd in one step.
mkcd() { mkdir -p -- "$1" && cd -- "$1" }

# Fuzzy-pick a git branch and switch to it.
gsf() {
  local branch
  branch=$(git branch --all --format='%(refname:short)' |
    sed 's|^origin/||' | sort -u |
    fzf --preview 'git log --oneline --graph --decorate --color=always {} | head -50') || return
  git switch "$branch"
}

# Fuzzy-pick a file from the current tree and open it in nvim.
vf() {
  local file
  file=$(fzf --preview 'bat --color=always --style=numbers --line-range=:300 {}') || return
  "$EDITOR" "$file"
}

# Extract any archive without remembering which flags each one wants.
extract() {
  [[ -f "$1" ]] || { print -u2 "extract: no such file: $1"; return 1 }
  case "$1" in
    *.tar.bz2|*.tbz2) tar xjf "$1" ;;
    *.tar.gz|*.tgz)   tar xzf "$1" ;;
    *.tar.xz)         tar xJf "$1" ;;
    *.tar)            tar xf  "$1" ;;
    *.bz2)            bunzip2 "$1" ;;
    *.gz)             gunzip  "$1" ;;
    *.zip)            unzip   "$1" ;;
    *.7z)             7z x    "$1" ;;
    *)                print -u2 "extract: don't know how to handle $1"; return 1 ;;
  esac
}

# cd into the directory spf was quit in (cd_on_quit in its config)
spf() {
  command spf "$@"
  local last="$XDG_STATE_HOME/superfile/lastdir"
  [[ -f "$last" ]] && { source "$last"; rm -f -- "$last" }
}

# mqsub <topic> [jq-filter]: subscribe and pretty-print the JSON payloads.
# MQ_HOST and MQ_USER come from .zshrc.local (git-ignored), MQ_PORT defaults to
# 1883. The password is kept in the Keychain, so on a new machine run once:
#   security add-generic-password -s mqsub -a "$MQ_USER" -w
mqsub() {
  local topic=$1 filter=${2:-.} pw
  [[ -n $topic ]] || {
    print -u2 "usage: mqsub <topic> [jq-filter]"
    return 1
  }
  [[ -n $MQ_HOST && -n $MQ_USER ]] || {
    print -u2 "mqsub: set MQ_HOST and MQ_USER in \$ZDOTDIR/.zshrc.local"
    return 1
  }
  pw=$(security find-generic-password -s mqsub -a "$MQ_USER" -w 2>/dev/null) || {
    print -u2 "mqsub: no password in the Keychain; run: security add-generic-password -s mqsub -a $MQ_USER -w"
    return 1
  }
  # -o takes the credentials from a file descriptor instead of argv. With -P the
  # password sits in `ps` output for every user on the machine, for as long as
  # the subscription runs, which defeats keeping it in the Keychain at all.
  mosquitto_sub -o <(printf -- '-u %s\n-P %s\n' "$MQ_USER" "$pw") \
    -h "$MQ_HOST" -p "${MQ_PORT:-1883}" -v -t "$topic" |
  # ponytail: assumes one message per line, which is what the hub publishes. A
  # payload containing a literal newline is read as a second message with a junk
  # topic; mosquitto_sub -F with an explicit delimiter is the way out if it happens.
  while IFS=' ' read -r t payload; do
    print -P -- "%F{cyan}${t//\%/%%}%f  %F{8}%D{%T}%f"
    printf '%s\n' "$payload" | jq -C "$filter" 2>/dev/null || printf '%s\n' "$payload"
  done
}
