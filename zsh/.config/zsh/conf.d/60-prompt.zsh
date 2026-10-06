# Prompt. Loaded last so starship's precmd hook is installed after everything
# else that registers one.

# Config lives in starship/.config/starship.toml. Only the cache location is
# pinned here, to keep it out of $HOME.
export STARSHIP_CACHE="$XDG_CACHE_HOME/starship"

eval "$(starship init zsh)"
