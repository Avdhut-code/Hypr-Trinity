#!/bin/bash
set -e

SCRIPT_PATH=$(realpath "$0")

if [ "$1" != "--interactive" ]; then
	alacritty --config-file "${HOME}/.local/share/Hypr-Trinity/config/alacritty/exit-config.toml" --class exit-hyprland-pass -T "Exit-hyprland-pass" -e bash "$SCRIPT_PATH" --interactive
	exit 0
fi

sleep 0.05

clear

cols=$(tput cols)
lines=$(tput lines)

print_center() {
  	local text="$1"
  	local padding=$(( (cols - ${#text}) / 2 ))
  	if [ "$padding" -gt 0 ]; then
  	  	printf "%*s" "$padding" ""
  	fi
  	printf "%s\n" "$text"
}

content=(
  	"┌───────────────────────────────────────────────┐"
  	"│          Switch-Off / Exit Hyprland ?         │"
  	"└───────────────────────────────────────────────┘"
)

content_height=${#content[@]}
top=$(( (lines - content_height - 3) / 2 ))

if [ "$top" -gt 0 ]; then
	for ((i=0; i<top; i++)); do
		printf "\n"
	done
fi

for line in "${content[@]}"; do
	print_center "$line"
done
printf "\n"

prompt="Choose action [s]hutdown, [e]xit Hyprland, [r]eboot, [c]ancel: "
left=$(( (cols - ${#prompt}) / 2 ))
if [ "$left" -gt 0 ]; then
	read -rp "$(printf '%*s' "$left" '')$prompt" ans
else
	read -rp "$prompt" ans
fi

case "$ans" in
	[Ss]*)
	    	echo "Shutting down system..."
	    	sleep 0.5
	    	systemctl poweroff
	    	;;
	[Ee]*)
	    	echo "Exiting Hyprland session..."
	    	sleep 0.5
	    	hyprctl --batch "dispatch 'hl.dsp.exit()'
	    	;;
	[Rr]*)
	    	echo "Rebooting system..."
	    	sleep 0.5
	    	systemctl reboot
	    	;;
	*)
	    	echo "Cancelled."
	    	sleep 0.5
	    	;;
esac