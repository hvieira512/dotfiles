#!/usr/bin/env bash

# Get the current volume level
volume=$(pamixer --get-volume)

# Get the mute status
if pamixer --get-mute; then
  icon="🔊"
else
  icon="🔇"
fi

# Generate a progress bar (10 segments for simplicity)
progress_bar=$(seq -s "█" 0 $((volume / 5)) | sed 's/[0-9]//g')
empty_bar=$(seq -s "░" 0 $(((100 - volume) / 5)) | sed 's/[0-9]//g')

# Show the notification with the progress bar
dunstify -r 2593 -u low "$icon ${progress_bar}${empty_bar} ${volume}%"
