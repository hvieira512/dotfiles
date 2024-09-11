#!/bin/bash

# Get the current state of the devices
touchpad_id=13
keyboard_id=14

touchpad_status=$(xinput list-props $touchpad_id | grep "Device Enabled" | awk '{print $4}')
keyboard_status=$(xinput list-props $keyboard_id | grep "Device Enabled" | awk '{print $4}')

# Toggle the touchpad
if [ "$touchpad_status" -eq 0 ]; then
    xinput enable $touchpad_id
    echo "Touchpad enabled"
else
    xinput disable $touchpad_id
    echo "Touchpad disabled"
fi

# Toggle the keyboard
if [ "$keyboard_status" -eq 0 ]; then
    xinput enable $keyboard_id
    echo "Keyboard enabled"
else
    xinput disable $keyboard_id
    echo "Keyboard disabled"
fi
