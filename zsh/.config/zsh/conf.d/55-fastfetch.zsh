# System info on every new shell. Config in fastfetch/.config/fastfetch/.
#
# fastfetch leaves a blank 28x15 logo and a background job flies the shiny
# Charizard frames into it over the kitty protocol until the first command.
# Fastfetch can't animate, and Ghostty ignores kitty animation frames, so each
# frame is a fresh image, drawn at a fixed row.
zmodload zsh/zselect

() {
  local frames=(~/.local/share/fastfetch/charizard/*.png(N)) pos row k
  (( $#frames )) && print -n '\e[6n' && read -rs -t 1 -d R pos || { fastfetch; return }
  row=${${pos#*\[}%;*}

  # The frames go to a fixed row, so nothing may scroll: fastfetch prints 16
  # lines and the prompt 3 more. Scroll up front if that doesn't fit.
  k=$(( row + 18 - LINES ))
  (( k > 0 )) && { print -n "${(pl:k::\n:)}\e[${k}A"; (( row -= k )) }
  fastfetch
  (( row > 0 )) || return

  {
    trap exit TERM # deferred to between frames, never mid escape sequence
    local paths=() i id=6 old
    while :; do
      for i in {1..$#frames}; do
        [[ -n $paths[i] ]] || paths[i]=$(print -rn -- $frames[i] | base64)
        # The terminal reads the PNG itself (t=f), so a frame is one short
        # write: the prompt can't land in the middle of it, and the cursor is
        # away too briefly to blink. Two ids, so the old frame stays up until
        # the new one is placed.
        (( old = id, id = id == 6 ? 7 : 6 ))
        print -rn -- $'\e_Ga=t,t=f,f=100,i='$id$',q=2;'$paths[i]$'\e\\\e7\e['$row$';1H\e_Ga=p,i='$id$',p=1,c=28,r=15,C=1,q=2\e\\\e8\e_Ga=d,d=i,i='$old$',q=2\e\\' 2>/dev/null || exit
        zselect -t 5 # the GIF runs at 50 ms a frame
      done
    done
  } &!
  _charizard_pid=$!
  preexec_functions+=(_charizard_stop)
}

_charizard_stop() {
  preexec_functions=(${preexec_functions:#_charizard_stop})
  kill $_charizard_pid 2>/dev/null || return
  # Let it finish the frame it's on before the command writes anything
  while kill -0 $_charizard_pid 2>/dev/null; do zselect -t 1; done
  unset _charizard_pid
}
