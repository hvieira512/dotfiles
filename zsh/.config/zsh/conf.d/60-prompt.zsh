# Prompt. Loaded last so starship's precmd hook is installed after everything
# else that registers one.

# No starship.toml is tracked: the prompt runs on starship's built-in defaults,
# which already cover the git branch, git status and per-language version
# segments. Only the cache location is pinned, to keep it out of $HOME.
export STARSHIP_CACHE="$XDG_CACHE_HOME/starship"

eval "$(starship init zsh)"
