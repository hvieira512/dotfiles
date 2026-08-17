# Shell integrations and plugins.
#
# Plugins come from Homebrew rather than a plugin manager: `brew upgrade` keeps
# them current, there's no bootstrap step on a new machine, and startup stays
# fast because nothing has to clone or compile at first launch.
#
# Order in this file is load-bearing. fzf-tab needs compinit (20-completion.zsh)
# to have run, and fast-syntax-highlighting wraps every ZLE widget so it has to
# see the final set — it goes last.

_zsh_share="${HOMEBREW_PREFIX:-/opt/homebrew}/share"

# --- fzf --------------------------------------------------------------------
# Back every fzf-driven search with fd so results honour .gitignore and skip
# .git. Set before sourcing anything that reads these.
export FZF_DEFAULT_COMMAND='fd --type file --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type directory --hidden --follow --exclude .git'

export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:300 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --icons --colour=always {}'"
export FZF_CTRL_R_OPTS="--reverse --preview 'echo {}' --preview-window=down:3:hidden:wrap --bind '?:toggle-preview'"

# Rose Pine Moon, so the picker matches ghostty, tmux, bat and nvim. `bg:-1`
# keeps the terminal background rather than painting over it.
export FZF_DEFAULT_OPTS="
  --height=60% --layout=reverse --border=rounded --info=inline --cycle
  --color=fg:#908caa,bg:-1,hl:#ea9a97
  --color=fg+:#e0def4,bg+:#393552,hl+:#ea9a97
  --color=border:#44415a,header:#3e8fb0,gutter:-1
  --color=spinner:#f6c177,info:#9ccfd8,pointer:#c4a7e7
  --color=marker:#eb6f92,prompt:#908caa"

# ^R history, ^T file picker, alt-C directory jump. fzf binds the emacs, viins
# and vicmd keymaps explicitly, so `bindkey -v` in 40- doesn't undo any of it.
source <(fzf --zsh)

# --- zoxide -----------------------------------------------------------------
# `z dev` jumps to the most-used directory matching "dev"; `zi` picks one
# interactively through fzf. Plain `cd` is untouched.
eval "$(zoxide init zsh)"

# --- fzf-tab ----------------------------------------------------------------
# Replaces the completion menu with an fzf picker, with previews per command.
source "$_zsh_share/fzf-tab/fzf-tab.zsh"

zstyle ':fzf-tab:*' switch-group ',' '.'          # cycle between groups
zstyle ':fzf-tab:*' fzf-min-height 15
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' prefix ''                     # drop the leading · marker

# $realpath is fzf-tab's variable for the candidate under the cursor.
zstyle ':fzf-tab:complete:(cd|z|ls|ll|la|eza|__zoxide_z):*' \
  fzf-preview 'eza --tree --level=2 --icons --colour=always $realpath'
zstyle ':fzf-tab:complete:(bat|cat|nvim|vim|v|less):*' \
  fzf-preview 'bat --color=always --style=numbers --line-range=:300 $realpath'
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
  fzf-preview 'echo ${(P)word}'
zstyle ':fzf-tab:complete:git-(add|diff|restore|checkout|switch):*' \
  fzf-preview 'git diff --color=always -- $realpath'

# --- version and env managers ----------------------------------------------
# mise: per-project runtime versions. Inert until a project has a .mise.toml or
# .tool-versions, so the brew-installed node/python/go stay in charge by default.
eval "$(mise activate zsh)"

# direnv: per-project env from .envrc, after mise so its hook runs last.
eval "$(direnv hook zsh)"

# --- ZLE plugins ------------------------------------------------------------
# Prefix search on Up/Down. Bound in 40-keybindings.zsh.
source "$_zsh_share/zsh-history-substring-search/zsh-history-substring-search.zsh"
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=#f6c177,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=#eb6f92,bold'
HISTORY_SUBSTRING_SEARCH_FUZZY='true'

# Ghost text from history, accepted with -> or End.
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6e6a86'   # rose-pine `muted`
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20             # don't suggest against huge pastes
source "$_zsh_share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Must be last: it wraps every widget defined up to this point.
source "$_zsh_share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

unset _zsh_share
