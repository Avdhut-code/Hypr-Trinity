#!/bin/bash

# [ USE ]
# customlinkopenr <url> <icon-path> 

if [ -z "$1" ]; then
    echo "Error: No URL argument provided."
    exit 1
fi
 
URL="$1"
ICON="$2"
 
/usr/bin/env -S bash -c 'exec -a zenlaunch zen --new-tab "$1"' -- "$URL" &

notify-send -u low "Web-App-Launcher" "$URL Opened" --icon="$ICON" -t 1000 --hint=boolean:transient:true
 
hyprctl dispatch workspace 2