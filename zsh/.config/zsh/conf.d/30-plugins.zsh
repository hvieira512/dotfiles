# Shell integrations and plugins, all from Homebrew (no plugin manager).
# Order matters: fzf-tab needs compinit (20-), syntax highlighting goes last.

_zsh_share="${HOMEBREW_PREFIX:-/opt/homebrew}/share"

# --- fzf --------------------------------------------------------------------
# fd so results honour .gitignore; set before anything reads these.
export FZF_DEFAULT_COMMAND='fd --type file --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type directory --hidden --follow --exclude .git'

export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:300 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --icons --colour=always {}'"
export FZF_CTRL_R_OPTS="--reverse --preview 'echo {}' --preview-window=down:3:hidden:wrap --bind '?:toggle-preview'"

# Rose Pine Moon; bg:-1 keeps the terminal background.
export FZF_DEFAULT_OPTS="
  --height=60% --layout=reverse --border=rounded --info=inline --cycle
  --color=fg:#908caa,bg:-1,hl:#ea9a97
  --color=fg+:#e0def4,bg+:#393552,hl+:#ea9a97
  --color=border:#44415a,header:#3e8fb0,gutter:-1
  --color=spinner:#f6c177,info:#9ccfd8,pointer:#c4a7e7
  --color=marker:#eb6f92,prompt:#908caa"

# ^R history, ^T files, alt-C dirs; bound in every keymap, so bindkey -v keeps them.
source <(fzf --zsh)

# --- zoxide -----------------------------------------------------------------
# z <dir> jumps to the most-used match, zi picks with fzf.
eval "$(zoxide init zsh)"

# --- fzf-tab ----------------------------------------------------------------
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
# mise only acts in projects with .mise.toml/.tool-versions; brew runtimes otherwise.
eval "$(mise activate zsh)"

# direnv after mise so its hook runs last.
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
