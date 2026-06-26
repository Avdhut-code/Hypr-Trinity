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

timeout_secs=10
elapsed=0

while ! pgrep -x "zenlaunch" >/dev/null; do
    sleep 0.2
    elapsed=$(echo "$elapsed + 0.2" | bc)
    if (( $(echo "$elapsed >= $timeout_secs" | bc -l) )); then
        notify-send -u critical "Web-App-Launcher" "Timed out waiting for zen to launch ($URL)"
        exit 1
    fi
done
 
notify-send -u low "Web-App-Launcher" "$URL Opened" --icon="$ICON"
 
hyprctl dispatch workspace 2