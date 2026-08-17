# Interactive shell config.
#
#   ~/.zshenv            every zsh, including scripts — XDG vars and ZDOTDIR
#   $ZDOTDIR/.zprofile   login shells — PATH and exported env
#   $ZDOTDIR/.zshrc      this file — interactive only
#
# Nothing of substance lives here. The real config is in conf.d/, sourced in
# filename order, so the numeric prefixes *are* the load order and it matters:
# options before completion, completion before fzf-tab, plugins before the
# keybindings that rebind their widgets.

for _zsh_conf in "$ZDOTDIR"/conf.d/*.zsh(N); do
  source "$_zsh_conf"
done
unset _zsh_conf

# Machine-specific settings that shouldn't live in a public repo — work tokens,
# client paths, one-off PATH entries. Git-ignored; create it by hand as needed.
[[ -r "$ZDOTDIR/.zshrc.local" ]] && source "$ZDOTDIR/.zshrc.local"
