#!/bin/bash

playerctl position 0 
notify-send -t 1000 \
        --hint=boolean:transient:true \
        -i "$HOME/.local/share/Hypr-Trinity/icon/playerctl-play-pause.png" \
        "Audio/Video Ctl" \
        "$(playerctl metadata --format 'Replaying : {{title}} from {{playerName}}')"