#!/usr/bin/env bash

# Adjust the brightness
brightnessctl set "$1"

# Get the current brightness level as a percentage
brightness=$(brightnessctl get)
max_brightness=$(brightnessctl max)
brightness_percent=$((100 * brightness / max_brightness))

# Generate a progress bar (10 segments for simplicity)
progress_bar=$(seq -s "█" 0 $((brightness_percent / 10)) | sed 's/[0-9]//g')
empty_bar=$(seq -s "░" 0 $(((100 - brightness_percent) / 10)) | sed 's/[0-9]//g')

# Show the notification with the progress bar
dunstify -r 2594 -u low "💡 [${progress_bar}${empty_bar}] ${brightness_percent}%"
