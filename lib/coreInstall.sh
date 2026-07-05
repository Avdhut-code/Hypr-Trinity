#!/bin/bash 

repoCopyToTarget() {
    log_info "Moving suite to permanent home: $TARGET_DIR"

    if [ "$ORIGINAL_DIR" = "$TARGET_DIR" ]; then
        log_info "Already in target directory, skipping copy."
        return
    fi

    mkdir -p "$TARGET_DIR"
    rsync -a "${ORIGINAL_DIR}/" "${TARGET_DIR}/"

    log_success "Dotfiles centralized. All future operations will use $TARGET_DIR"
}

takePermissions() {
	log_info "Adding user to i2c group for DDC-CI brightness control..."
	
	log_info "Creating i2c group..."

	sudo groupadd i2c 2>/dev/null || true

	if ! groups | grep -q i2c; then
		sudo usermod -aG i2c "$(whoami)"
		log_warning "i2c group membership requires logout/login to take effect"
	else
		log_success "User already in i2c group"
	fi


	log_info "Verifying ddcutil access..."

	if command -v ddcutil &>/dev/null; then
		if ddcutil detect >/dev/null 2>&1; then
			log_success "ddcutil display detected"
		else
			log_warning "ddcutil installed but no displays detected (DDC-CI may not be available)"
		fi
	fi

	log_success "Permissions set for ~/.local/bin"
}

backupConfigs() {
	if [ "${IS_UPDATE}" == true ] ; then 
        	log_info "Update mode — skipping backup"
        	return		
	fi

    	local backup_path

    	backup_path="${BACKUP_CONFIG_LOCATION}/backup_$(date +%Y-%m-%d_%H-%M-%S)"
   
	mkdir -p "$backup_path"

	log_info "Moving original ~/.config folders to backup folder"

	[ -d "${HOME}/.config/hypr" ]   && mv "${HOME}/.config/hypr" 	 	"$backup_path"
	[ -d "${HOME}/.config/waybar" ] && mv "${HOME}/.config/waybar" 		"$backup_path"
	[ -d "${HOME}/.config/wofi" ]   && mv "${HOME}/.config/wofi" 	 	"$backup_path"
	[ -d "${HOME}/.config/btop" ]   && mv "${HOME}/.config/btop" 	 	"$backup_path"
	
	[ -d "${HOME}/.config/swaync" ]   && mv "${HOME}/.config/swaync" 	"${backup_path}"

	log_success "Moved the original ${HOME}/.config to ${backup_path}"
}

simlinkCreate() {
	mkdir -p "${HOME}/.config"

	log_info "Config directories:"
	ln -sfn "${TARGET_DIR}/config/hypr" 		"${HOME}/.config/"
	ln -sfn "${TARGET_DIR}/config/waybar" 		"${HOME}/.config/"
	ln -sfn "${TARGET_DIR}/config/wofi" 		"${HOME}/.config/"
	ln -sfn "${TARGET_DIR}/config/btop" 		"${HOME}/.config/"
	ln -sfn "${TARGET_DIR}/config/swaync" 		"${HOME}/.config/"
	ln -sfn "${TARGET_DIR}/config/alacritty" 	"${HOME}/.config/"

	log_info "Scripts to ~/.local/bin:"

	mkdir -p "${HOME}/.local/bin"

	ln -sfn "${TARGET_DIR}/bin/custombrightnessctl.sh"      	"${HOME}/.local/bin/custombrightnessctl"
	ln -sfn "${TARGET_DIR}/bin/custombtoplauncher.sh" 		"${HOME}/.local/bin/custombtoplauncher"
	ln -sfn "${TARGET_DIR}/bin/customlinkopenr.sh"   		"${HOME}/.local/bin/customlinkopenr"
	ln -sfn "${TARGET_DIR}/bin/customhyprlandexit.sh"       	"${HOME}/.local/bin/customhyprlandexit"
	ln -sfn "${TARGET_DIR}/bin/customwofisearch.sh"         	"${HOME}/.local/bin/customwofisearch"
	ln -sfn "${TARGET_DIR}/bin/customwallpaperswitcher.sh"  	"${HOME}/.local/bin/customwallpaperswitcher"

	log_info "Setting script permissions..."
	
	chmod +x "${TARGET_DIR}/bin/customwofisearch.sh"         
	chmod +x "${TARGET_DIR}/bin/customhyprlandexit.sh"       
	chmod +x "${TARGET_DIR}/bin/customlinkopenr.sh"   	
	chmod +x "${TARGET_DIR}/bin/custombtoplauncher.sh" 	
	chmod +x "${TARGET_DIR}/bin/custombrightnessctl.sh"      
	chmod +x "${TARGET_DIR}/bin/customwallpaperswitcher.sh"      

	log_info "GTK theme:"

	mkdir -p "${HOME}/.local/share/themes"

	ln -sfn "${TARGET_DIR}/theme/gtkThemes/Graphite-Dark" "${HOME}/.local/share/themes/"

	log_success "Created symlink(s)"
}

bashAppend() {
	if [ ! -f "${HOME}/.bashrc" ]; then
		exit_with_error "${HOME}/.bashrc not found"
	fi

	if grep -q "# === HYPRLAND CONFIG START ===" "${HOME}/.bashrc"; then
		log_info "hyprland configuration already in .bashrc (skipping)"
		return
	fi

	if [ -f "$ORIGINAL_DIR/bashAppend.sh" ]; then
		cat "$ORIGINAL_DIR/bashAppend.sh" >> "${HOME}/.bashrc"
		log_success ".bashrc configured with path export and environment variables"
	else
		log_warning "bashAppend.sh not found, skipping .bashrc modification"
	fi
}

themeApply() {
	log_info "Applying GTK theme..."
	
	local theme="Graphite-Dark"
	local desktop="${XDG_CURRENT_DESKTOP:-}"

	if [ -z "$desktop" ]; then
		desktop="${DESKTOP_SESSION:-}"
	fi

	log_info "Detected desktop: ${desktop:-unknown}"

	case "${desktop,,}" in  
		*xfce*)
			xfconf-query -c xsettings -p /Net/ThemeName -s "$theme" 2>/dev/null \
				&& log_success "XFCE theme set" \
				|| log_warning "xfconf-query failed — install xfce4-settings"
		;;
		*cinnamon*)
			gsettings set org.cinnamon.desktop.interface gtk-theme "$theme" 2>/dev/null \
				&& log_success "Cinnamon theme set" \
				|| log_warning "Could not set Cinnamon theme"
		;;
		*gnome*)
			gsettings set org.gnome.desktop.interface gtk-theme "$theme" 2>/dev/null \
				&& log_success "GNOME theme set" \
				|| log_warning "Could not set GNOME theme"
		;;
		*hyprland*|*sway*|*wlroots*)
			gsettings set org.gnome.desktop.interface gtk-theme "$theme" 2>/dev/null \
				&& log_success "Wayland session theme set" \
				|| log_warning "Could not set theme"
		;;
		*)
			log_warning "Unknown desktop: '${desktop}' — trying gsettings anyway"
			gsettings set org.gnome.desktop.interface gtk-theme "$theme" 2>/dev/null \
				|| log_warning "Theme could not be applied, set it manually"
		;;
	esac
}

fontInstall() {
	local font_name="JetBrainsMono"
	local font_dir="${TARGET_DIR}/fonts"
	local font_path="${font_dir}/${font_name}/JetBrainsMonoNerdFont-Regular.ttf"

	if [[ -f "${font_path}" ]]; then
    		log_success "JetBrains Mono Nerd Font already installed, skipping."
    		return
	fi

	log_info "Downloading ${font_name} Nerd Font..."
	mkdir -p "$font_dir"

	local tarball_path="/tmp/${font_name}.tar.xz"
    	local download_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font_name}.tar.xz"

	if curl -L "$download_url" -o "$tarball_path"; then

		log_info "Extracting font..."
		mkdir -p "${font_dir}/${font_name}"
		tar -xf "$tarball_path" -C "${font_dir}/${font_name}"
		rm "$tarball_path"

		log_info "Symlinking to ~/.local/share/fonts..."
		mkdir -p "${HOME}/.local/share/fonts"
		ln -sfn "${TARGET_DIR}/fonts/${font_name}" "${HOME}/.local/share/fonts/"

		log_info "Refreshing font cache..."
		fc-cache -f "${HOME}/.local/share/fonts" 2>/dev/null || log_warning "fc-cache failed — you may need to run it manually"

		log_success "${font_name} Nerd Font installed"
	else
		log_warning "Failed to download font"
	fi
}