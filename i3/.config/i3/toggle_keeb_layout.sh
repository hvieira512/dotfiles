#!/bin/bash

current_variant=$(setxkbmap -query | awk '/variant/ {print $2}')

if [ -z "$current_variant" ]; then
    setxkbmap -layout us -variant intl
else
    setxkbmap -layout us
fi

#polybar-msg action keyboard restart &
polybar-msg cmd restart
