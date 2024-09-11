#!/bin/bash

# Save the current workspace name
workspace=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name')

# Send all windows in the current workspace to the scratchpad
i3-msg "[workspace=\"$workspace\"] move scratchpad"
