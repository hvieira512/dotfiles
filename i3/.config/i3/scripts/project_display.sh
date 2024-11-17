
#!/bin/bash

# Define your screen names (you can use `xrandr` to check the names of your screens)
PRIMARY="HDMI-1"  # Adjust this with your primary display
SECONDARY="eDP-1"  # Adjust this with your secondary display

# Define rofi options
OPTIONS="First screen only\nSecond screen only\nSame image in both displays\nExtend displays"

# Use rofi to show the menu and capture the selected option
SELECTION=$(echo -e "$OPTIONS" | rofi -dmenu -p "Select display option:")

# Based on the selection, run the appropriate xrandr command
case "$SELECTION" in
    "First screen only")
        xrandr --output "$SECONDARY" --auto --output "$PRIMARY" --off
        ;;
    "Second screen only")
        xrandr --output "$PRIMARY" --auto --output "$SECONDARY" --off
        ;;
    "Same image in both displays")
        xrandr --output "$PRIMARY" --primary --auto --output "$SECONDARY" --auto --same-as "$PRIMARY"
        ;;
    "Extend displays")
        xrandr --output "$PRIMARY" --primary --auto --output "$SECONDARY" --auto --left-of "$PRIMARY"
        ;;
    *)
        echo "Invalid option selected."
        ;;
esac
