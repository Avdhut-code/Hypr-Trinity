#!/bin/bash

playerctl position 0 
notify-send -t 1000 \
        -i "$HOME/.local/share/LinuxMintHyprlandConfig/icon/playerctl-play-pause.png" \
        "Audio/Video Ctl" \
        "$(playerctl metadata --format 'Replaying : {{title}} from {{playerName}}')" """