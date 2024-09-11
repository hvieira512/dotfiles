#!/bin/bash

# Set the battery threshold level
LOW_BATTERY_LEVEL=20
BRIGHTNESS_LEVEL=30%
FULL_BRIGHTNESS=100%

# Variable to track whether brightness was reduced
brightness_reduced=false

while true; do
  # Check if AC power is connected
  if acpi -a | grep -q "on-line"; then
    # Set brightness to full when plugged in
    brightnessctl set $FULL_BRIGHTNESS
    echo "AC power connected. Setting brightness to $FULL_BRIGHTNESS."

    # Reset flag and sleep before next check
    brightness_reduced=false
    sleep 60 # Adjust as needed to avoid frequent checks
    continue
  fi

  # Get the current battery level for Battery 1
  BATTERY_LEVEL=$(acpi -b | grep "Battery 1" | grep -P -o '[0-9]+(?=%)')

  # Debugging output to check the extracted battery level
  echo "Battery 1 Level: $BATTERY_LEVEL"

  # Check if the battery level is an integer and below the threshold
  if [[ $BATTERY_LEVEL =~ ^[0-9]+$ && $BATTERY_LEVEL -le $LOW_BATTERY_LEVEL && ! $brightness_reduced ]]; then
    # Reduce brightness if not already reduced
    brightnessctl set $BRIGHTNESS_LEVEL
    echo "Reducing brightness to $BRIGHTNESS_LEVEL."
    brightness_reduced=true
  elif [[ $BATTERY_LEVEL =~ ^[0-9]+$ && $BATTERY_LEVEL -gt $LOW_BATTERY_LEVEL && $brightness_reduced ]]; then
    # Restore full brightness if battery level is above threshold and brightness was reduced
    brightnessctl set $FULL_BRIGHTNESS
    echo "Battery level above threshold. Setting brightness to $FULL_BRIGHTNESS."
    brightness_reduced=false
  fi

  # Wait before checking again
  sleep 30
done
