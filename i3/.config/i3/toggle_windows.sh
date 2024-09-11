#!/bin/bash

# Check if there are any windows in the scratchpad
scratchpad_windows=$(i3-msg -t get_tree | jq '[recurse(.nodes[]?) | select(.name == "__i3_scratch") | .nodes[].nodes[]? | select(.name != "__i3_scratch") | select(.window)] | length')

if [ "$scratchpad_windows" -gt 0 ]; then
    # Show all windows from the scratchpad
    i3-msg '[scratchpad] scratchpad show'
    i3-msg '[class="."] fullscreen enable'
else
    # Save the current workspace name
    workspace=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name')
    # Send all windows in the current workspace to the scratchpad
    i3-msg "[workspace=\"$workspace\"] move scratchpad"
fi
