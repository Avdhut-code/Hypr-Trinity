#!/bin/bash

STATE_FILE="$HOME/.local/share/Hypr-Trinity/.waybar_output"

if command -v waybar > /dev/null 2>&1; then
    if ! pgrep -x "waybar" > /dev/null; then
        waybar & || notify-send \
        -t 1000 \
        --hint=boolean:transient:true \
        "Tool issue" \
        "Waybar failed to start. Please check your Waybar configuration."
    fi
else
    notify-send \
    -t 1000 \
    --hint=boolean:transient:true \
    "Tool issue" \
    "Waybar is not installed. Please install Waybar to use this script."
fi