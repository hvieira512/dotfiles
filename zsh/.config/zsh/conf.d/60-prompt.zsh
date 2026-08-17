# Prompt. Loaded last so starship's precmd hook is installed after everything
# else that registers one.

# starship looks for ~/.config/starship.toml by default; this repo stows it one
# level deeper to keep the package self-contained, so point at it explicitly.
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
export STARSHIP_CACHE="$XDG_CACHE_HOME/starship"

eval "$(starship init zsh)"
