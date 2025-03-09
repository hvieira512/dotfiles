# startup commands
if status is-interactive
    fortune | cowsay -f stegosaurus
end

starship init fish | source

set -x BRAVE_PROFILE ~/shared-brave-profile

set -gx VISUAL nvim
set -gx EDITOR nvim

# aliases
alias kickstart "NVIM_APPNAME=kickstart nvim"
alias vim nvim
alias lazyvim "NVIM_APPNAME=lazyvim nvim"
alias v nvim
alias docker-start "systemctl --user enable docker-desktop"
alias docker-stop "systemctl --user stop docker-destop"

# Ensure /usr/bin/go is only added once to PATH
if not string match -q -- /usr/bin/go $PATH
    set -gx PATH /usr/bin/go $PATH
end

# go variables
set -gx GOPATH $HOME/go
set -gx GOROOT /usr/lib/go
set -Ux fish_user_paths $HOME/go/bin $fish_user_paths

# pnpm
set -gx PNPM_HOME "/home/vieira/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end

# bashbunni pomodoro cli timmer
# Define pomodoro options as key-value pairs
set -l pomo_options_work 45
set -l pomo_options_break 10

function pomodoro 
  echo $argv[1] | lolcat
  timer "$argv[2]"m 
  ep "'$argv[1]' session done"
end

alias po="pomodoro"
alias wo="pomodoro work 45"
alias br="pomodoro break 10"

# flutter variables
set -Ux ANDROID_HOME $HOME/android-sdk
set -Ux PATH $ANDROID_HOME/emulator $ANDROID_HOME/tools $ANDROID_HOME/tools/bin $ANDROID_HOME/platform-tools $PATH
set -U fish_user_paths $ANDROID_HOME/platform-tools $fish_user_paths
set -Ux JAVA_HOME /usr/lib/jvm/java-17-openjdk
set -x PATH $JAVA_HOME/bin $PATH
set -Ux CHROME_EXECUTABLE /usr/bin/brave

zoxide init fish | source
