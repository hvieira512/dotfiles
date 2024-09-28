# if status is-interactive
# end

starship init fish | source

set -x BRAVE_PROFILE ~/shared-brave-profile

set -gx VISUAL nvim
set -gx EDITOR nvim

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

# pomodoro timer (bashbunni)
# Study stream aliases for fish shell
# Requires https://github.com/caarlos0/timer to be installed. spd-say should ship with your distro
function pomodoro
    set -l val $argv[1]
    if test -n "$val" 
        switch "$val"
            case 'work'
                echo "work" | lolcat
                timer 45m
                spd-say "'work' session done"
            case 'break'
                echo "break" | lolcat
                timer 10m
                spd-say "'break' session done"
        end
    end
end

alias wo="pomodoro work"
alias br="pomodoro break"
