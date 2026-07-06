#!/bin/bash

USER_INPUT=$(
	wofi \
	--dmenu \
	--style "$HOME/.local/share/Hypr-Trinity/config/wofi/wofisearchstyle.css"
)

if [ -z "$USER_INPUT" ]; then
	hyprctl eval 'hl.notification.create({ text = "No input provided.", timeout = 3000, font_size = 15, icon = 3 })'
  	exit 1
fi

ENCODED_QUERY=$(printf '%s' "$USER_INPUT" | sed 's/ /+/g')

QUERY_STRING="https://google.com/search?q=$ENCODED_QUERY"

zen --new-tab "$QUERY_STRING"

hyprctl --batch "dispatch hl.dsp.focus({ workspace = 2 })"