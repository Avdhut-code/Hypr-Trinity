#!/bin/bash

WALLPAPER_DIR="$HOME/.local/share/LinuxMintHyprlandConfig/wallpaper"
STATE_FILE="$HOME/.local/share/LinuxMintHyprlandConfig/.wallpaper_state"
ICON="$HOME/.local/share/LinuxMintHyprlandConfig/icon/wallpaper-switcher.png"
BASHRC="$HOME/.bashrc"

if [ -z "$1" ]; then
    echo "Usage: wallpaperswitcher [+|-]"
    exit 1
fi

if ! command -v swaybg >/dev/null 2>&1; then
    echo "Error: swaybg not found or not installed."
    exit 1
fi

mapfile -t WALLS < <(ls "$WALLPAPER_DIR"/wall*.png 2>/dev/null | sort)
TOTAL_WALLS=${#WALLS[@]}

if [ "$TOTAL_WALLS" -eq 0 ]; then
    echo "Error: No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

if [ -f "$STATE_FILE" ]; then
    CURRENT=$(cat "$STATE_FILE")
else
    CURRENT=0
fi

if [ "$CURRENT" -ge "$TOTAL_WALLS" ]; then
    CURRENT=0
fi

if [ "$1" == "+" ]; then
    NEXT=$(( (CURRENT + 1) % TOTAL_WALLS ))
elif [ "$1" == "-" ]; then
    NEXT=$(( (CURRENT - 1 + TOTAL_WALLS) % TOTAL_WALLS ))
else
    echo "Error: Unknown argument '$1'. Use + or -"
    exit 1
fi

SWITCHER_WALL="${WALLS[$NEXT]}"

pkill swaybg 2>/dev/null || true
swaybg -i "$SWITCHER_WALL" -m fill &

echo "$NEXT" > "$STATE_FILE"

if grep -q "export CURRENT_WALLPAPER=" "$BASHRC"; then
    sed -i "s|export CURRENT_WALLPAPER=.*|export CURRENT_WALLPAPER=\"${SWITCHER_WALL}\"|" "$BASHRC"
else
    echo "export CURRENT_WALLPAPER=\"${SWITCHER_WALL}\"" >> "$BASHRC"
fi

dWALL_NAME=$(basename "$SWITCHER_WALL")
notify-send -u low "Wallpaper" "$WALL_NAME" --icon="$ICON" -t 1000 --hint=boolean:transient:true