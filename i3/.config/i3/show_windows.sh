#!/bin/bash

# Show all windows from the scratchpad
i3-msg '[scratchpad] scratchpad show'

# Maximize all windows (or tile, depending on your layout preference)
# You may need to adjust the window IDs or criteria to fit your exact needs
i3-msg '[scratchpad] fullscreen enable'
