# Completion. This was missing entirely before — compinit was never called, so
# there was no tab completion for git branches, brew formulae, ssh hosts or
# anything else, despite brew's site-functions sitting on FPATH unused.

autoload -Uz compinit

# compinit's security audit stats every file in every fpath directory, which
# costs real time on a brew install. Run the full check once a day and reuse the
# cached dump the rest of the time. Delete the dump to force a rebuild after
# installing something that ships completions.
_zcompdump="$XDG_CACHE_HOME/zsh/zcompdump"
mkdir -p "${_zcompdump:h}"
if [[ -n $_zcompdump(#qN.mh-24) ]]; then
  compinit -C -d "$_zcompdump"
else
  compinit -d "$_zcompdump"
  # Compiling the dump makes the next startup load it as bytecode.
  [[ -f "$_zcompdump" && ( ! -f "$_zcompdump.zwc" || "$_zcompdump" -nt "$_zcompdump.zwc" ) ]] &&
    zcompile -R -- "$_zcompdump"
fi
unset _zcompdump

zmodload -i zsh/complist

# fzf-tab (30-plugins.zsh) replaces the built-in menu, and requires the built-in
# one to be off. Without fzf-tab you'd want `menu select` here instead.
zstyle ':completion:*' menu no

# Match in three passes, each tried only if the previous found nothing:
# case-insensitive, then partial words (`gco fo-ba` -> `foo-bar`), then anywhere
# in the string.
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=* r:|=*' \
  'l:|=* r:|=*'

zstyle ':completion:*' list-colors ''
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose true
zstyle ':completion:*' special-dirs true    # offer ./ and ../ as candidates
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' rehash true          # see newly installed binaries without `rehash`

zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:warnings'     format 'no matches: %d'
zstyle ':completion:*:corrections'  format '%d (errors: %e)'

# Completion results get their own on-disk cache, which mainly helps the slow
# ones (brew, docker, apt-style package lists).
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

# `kill <TAB>` should list your processes with enough detail to pick one.
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,%cpu,comm -w -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) #([^ ]#)*=01;34=0=01;31'

# Don't offer the current directory back to `cd ..`, and don't complete usernames
# for `cd` at all.
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories

# Skip the ~2000 system accounts macOS ships when completing a user.
zstyle ':completion:*:*:*:users' ignored-patterns \
  '_*' 'daemon' 'nobody' 'root' 'bin' 'sys' 'sshd' 'uucp' 'www*'
