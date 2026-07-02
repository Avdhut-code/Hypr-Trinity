#!/bin/sh

playerctl next
sleep 1
notify-send -t 1000 \
	--hint=boolean:transient:true \
	-i "$HOME/.local/share/Hypr-Trinity/icon/playerctl-play-pause.png" \
	"Audio/Video Ctl" \
        "$(playerctl metadata --format 'Next playing : {{title}} from {{playerName}}')"