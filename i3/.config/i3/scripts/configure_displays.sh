#!/bin/bash

HDMI_STATUS=$(xrandr | grep "HDMI-1 connected")

PRIMARY="HDMI-1"
SECONDARY="eDP-1"

if [ -n "$HDMI_STATUS" ]; then
    # xrandr --output HDMI-1 --primary --auto --right-of eDP-1 --output eDP-1 --auto
    xrandr --output HDMI-1 --primary --auto --output eDP-1 --off
else
    xrandr --output eDP-1 --primary --auto --output HDMI-1 --off
fi

