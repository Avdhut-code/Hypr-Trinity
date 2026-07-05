
# === HYPRLAND CONFIG START ===

export PATH="$HOME/.local/bin:$PATH"

# short hand function
function lk {
	cd $(walk "$@")
}

# env's for walk configuration/customization
export EDITOR=vim
export WALK_MAIN_COLOR="#5a5b5e"
export WALK_STATUS_BAR='[Mode(), Owner(), Size() | PadLeft(7), ModTime() | PadLeft(12)] | join(" ")'

# System tools environment variables
export CURRENT_WALLPAPER="${HOME}/.local/share/Hypr-Trinity/wallpaper/wall1.png"

# Make prompt bright bold neon green keep output white.
# PS1=' \[\033[1;32m\]\w >\[\033[0m\] ' ## neon-green

# Make prompt bright bold neon purple keep output white.
PS1=' \[\033[38;5;141m\]\w >\[\033[0m\] ' ## neon-purple

function q {
	exit
}


function F2 {
  	read -r -n 1 -s -p "Press ENTER to reboot, or any other key to cancel... " key

  	if [[ -z "$key" ]]; then
  	  	echo -e "\nRebooting now..."
  	  	systemctl reboot
  	else
  	  	echo -e "\nCancelled."
  	fi
}

function F1 {
  	read -r -n 1 -s -p "Press ENTER to poweroff, or any other key to cancel... " key
	
  	if [[ -z "$key" ]]; then
  	  	echo -e "\nPowering off now..."
  	  	systemctl poweroff
  	else
  	  	echo -e "\nCancelled."
  	fi
}

alias ~="cd ~"

alias ..="cd .."

# === HYPRLAND CONFIG END ===