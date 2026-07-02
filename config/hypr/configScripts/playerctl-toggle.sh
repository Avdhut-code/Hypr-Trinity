#!/bin/bash

playerctl play-pause
notify-send -t 1000 \
	--hint=boolean:transient:true \
	-i "$HOME/.local/share/Hypr-Trinity/icon/playerctl-play-pause.png" \
	"Audio/Video Ctl" \
	"$(playerctl metadata --format 'Paused : {{title}} from {{playerName}}')"