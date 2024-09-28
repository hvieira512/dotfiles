##!/bin/bash

# Check if HDMI-1 is connected
HDMI_STATUS=$(xrandr | grep "HDMI-1 connected")

if [ -n "$HDMI_STATUS" ]; then
    # HDMI-1 is connectted, set it as the primary monitor
    # xrandr --output HDMI-1 --primary --auto --output eDP-1 --off
    xrandr --output eDP-1 --auto --output HDMI-1 --primary --auto --right-of eDP-1
else
    # HDMI-1 is not connected, set eDP-1 as the primary monitor
    xrandr --output eDP-1 --primary --auto --output HDMI-1 --off
fi
