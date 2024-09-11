#!/bin/bash

layout=$(setxkbmap -query | grep layout | awk '{print $2}')
variant=$(setxkbmap -query | grep variant | awk '{print $2}')

if [ -z "$variant" ]; then
    echo "us"
else
    echo "us intl"
fi
