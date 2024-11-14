if status is-interactive
    fortune | cowsay -f stegosaurus
    # neofetch
end

starship init fish | source

set -x BRAVE_PROFILE ~/shared-brave-profile

set -gx VISUAL nvim
set -gx EDITOR nvim

# aliases
alias kickstart "NVIM_APPNAME=kickstart nvim"
alias vim nvim

# Ensure /usr/bin/go is only added once to PATH
if not string match -q -- /usr/bin/go $PATH
    set -gx PATH /usr/bin/go $PATH
end

set -gx GOPATH $HOME/go
set -gx GOROOT /usr/lib/go
set -Ux fish_user_paths $HOME/go/bin $fish_user_paths

# pnpm
set -gx PNPM_HOME "/home/vieira/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
