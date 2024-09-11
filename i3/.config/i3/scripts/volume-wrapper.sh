#!/bin/bash

# Run i3-volume to change volume
i3-volume "$@"

# Get current volume percentage
volume=$(i3-volume -p)

# Send notification to dunst
notify-send -u low -t 2000 "Volume Changed" "Current volume: ${volume}%"
