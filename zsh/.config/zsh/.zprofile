# Login-shell environment. Runs once per login shell, before .zshrc. PATH and
# other env that only humans need belongs here; env that scripts also need is in
# ~/.zshenv.

# Homebrew — puts /opt/homebrew/bin ahead of /usr/bin, and adds its
# share/zsh/site-functions to FPATH so compinit can pick up brew's completions.
eval "$(/opt/homebrew/bin/brew shellenv)"

# Unversioned `python3`/`python` from brew's python@3.13
export PATH="/opt/homebrew/opt/python@3.13/libexec/bin:$PATH"

# Where uv, pipx and friends drop executables.
export PATH="$HOME/.local/bin:$PATH"

# `go install` targets $GOPATH/bin, which is ~/go/bin unless GOPATH says
# otherwise. Left at the default so existing module downloads stay put.
export PATH="$HOME/go/bin:$PATH"

# Less: keep colour, don't clear the screen on exit, and treat a short file as
# not worth paging at all.
export LESS='--RAW-CONTROL-CHARS --no-init --quit-if-one-screen --mouse'

# bat renders man pages, matching the rose-pine theme in bat's own config.
export MANPAGER="sh -c 'col -bx | bat --language=man --plain'"
export MANROFFOPT='-c'
