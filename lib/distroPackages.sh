#!/bin/bash 

installPackagesDebian() {
    	sudo apt update
    	sudo apt install -y \
        	git \
		ddcutil \
		btop \
		htop \
		libnotify-bin \
		pavucontrol \
        	wireplumber \
		pipewire \
		playerctl \
		wofi \
		swaybg \
		sway-notification-center \
		evince \
		xed \
		nemo \
		mpv \
		curl \
		rsync \
		alacritty
	
    	sudo apt autoremove -y
    	sudo apt clean
}

installPackagesArch() {
    	sudo pacman -Syu --noconfirm
   	sudo pacman -S --noconfirm \
        	git ddcutil btop htop libnotify pavucontrol \
        	wireplumber playerctl wofi swaybg \
        	evince gedit nemo mpv curl \
		hyprland \
		hyprlock \
		hypridle \
		hyprpaper \
		waybar \
		swaync \
		pipewire \
		pipewire-pulse \
		polkit-gnome \
		xdg-desktop-portal-hyprland \
		uwsm \
		rsync \
		alacritty
}

installPackagesFedora() {
    	sudo dnf update -y
	sudo dnf copr enable sdegler/hyprland -y  	
	sudo dnf install -y \
        	git ddcutil btop htop libnotify pavucontrol \
        	wireplumber playerctl wofi swaybg \
        	evince xed nemo mpv curl \
		hyprland \
		hyprlock \
		hypridle \
		hyprpaper \
		waybar \
		SwayNotificationCenter \
		pipewire \
		pipewire-pulse \
		xdg-desktop-portal-hyprland \
		uwsm \
		fuse-libs \
		fuse \
		rsync \
		alacritty

	sudo dnf clean all 
}