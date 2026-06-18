#!/bin/sh
playerctl play-pause
notify-send -t 1000 \
	-i "$HOME/.local/share/LinuxMintHyprlandConfig/icon/playerctl-play-pause.png" \
	"Audio/Video Ctl" \
	"$(playerctl metadata --format 'Paused : {{title}} from {{playerName}}')"