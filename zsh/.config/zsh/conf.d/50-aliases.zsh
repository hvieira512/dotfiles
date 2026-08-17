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
alias dot='cd ~/dotfiles'
alias zc='$EDITOR $ZDOTDIR'
alias reload='exec zsh'
alias brewup='brew update && brew upgrade && brew cleanup'
# Rewrite the Brewfile from what's actually installed.
alias brewdump='brew bundle dump --describe --force --file=~/dotfiles/Brewfile'

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
