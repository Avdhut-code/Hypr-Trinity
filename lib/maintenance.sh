#!/bin/bash

installProceed(){
	cat << 'EOF'
This script will:
	• Check what distrobution you installing this onto
	• Install system packages (requires sudo)
	• Relocate suite to ~/.local/share/${PROJECT_NAME}
	• Create symlinks in ~/.local/bin (user-local, no sudo)
	• Moves the original Config folders to 'backupFolder' (folder from previous setup)
	• Create symlinks in ~/.config (user-local, no sudo)
	• Append to .bashrc with safe environment variables
	• Apply GTK theme with gesttings based on your desktop enviourment
	• Ask you to permission to install based on your desktop enviourment
	  - [ If you used the '--no-optional' tag, will skip over the permission ]
	
EOF
	read -p "Continue with installation? (y/n) [n]: " -r continue_install
	continue_install=${continue_install:-n}

	if [[ ! $continue_install =~ ^[Yy]$ ]]; then
		log_warning "Installation cancelled"
		exit 0
	fi
}

updateToolSimlink(){
	if [ ! -f "${TARGET_DIR}/install.sh" ]; then
		log_error "${TARGET_DIR}/install.sh not found"
		exit 1
	fi

	if [ "${SYMLINK_INSTALL_TOOL:-false}" == true ]; then
		log_info "Simlinking the install.sh tool"
	    	
		ln -sfn "${TARGET_DIR}/install.sh" "${HOME}/.local/bin/hyprtrinity"
		chmod +x "${TARGET_DIR}/install.sh"
		
		log_success "hyprtrinity symlinked to ~/.local/bin"
	fi
}

restoreConfigs() {
	log_section "Restoring Original Configs"

	local latest_backup
	latest_backup=$(ls -td "${BACKUP_CONFIG_LOCATION}"/backup_* 2>/dev/null | head -1)

	if [ -z "$latest_backup" ]; then
		log_error "No backup found in ${BACKUP_CONFIG_LOCATION}"
		exit 1
	fi

	log_info "Restoring from: $latest_backup"

	log_info "Removing symlinks..."
	
	rm -rf "${HOME}/.config/hypr"
	rm -rf "${HOME}/.config/waybar"
	rm -rf "${HOME}/.config/wofi"
	rm -rf "${HOME}/.config/btop"
	rm -rf "${HOME}/.config/swaync"
	
	rm -rf "${HOME}/.local/share/themes/Graphite-Dark"
	
	rm -f "${HOME}/.local/bin/custombrightnessctl"
	rm -f "${HOME}/.local/bin/custombtoplauncher"
	rm -f "${HOME}/.local/bin/customlinkopenr"
	rm -f "${HOME}/.local/bin/customhyprlandexit"
	rm -f "${HOME}/.local/bin/customwofisearch"

	log_info "Restoring config folders..."

	for folder in "$latest_backup"/*/; do
		local name
		name=$(basename "$folder")
		if [ -e "${HOME}/.config/$name" ]; then
			log_warning "${HOME}/.config/$name already exists, skipping"
		else
			mv "$folder" "${HOME}/.config/$name"
			log_success "Restored: ~/.config/$name"
		fi
	done

	log_warning "Installed packages and apps were NOT removed."
	echo ""
	echo "  To remove packages manually:"
	echo "   - refer to the README.md file to know the installed packages"
	echo "	 - then as per you distro Execute :"
	echo "     1. Debian : sudo apt remove [Package list without comma]"
	echo "     2. Arch   : sudo pacman -Rns [Package list without comma]"
	echo "     3. Fedora : sudo dnf remove [Package list without comma]"
	echo "                 (Note: Obsidian on Fedora is an AppImage — just delete:"
	echo "                 rm ${TARGET_DIR}/Apps/obsidian_*.AppImage"
	echo "                 rm ${HOME}/.local/bin/obsidian)"

	echo ""
	log_info "You can now delete the repo folder:"
	echo "  rm -rf ${TARGET_DIR}"
	echo "  rm -rf ${ORIGINAL_DIR}"

	log_success "Restore complete"
}

updateProject() {
	log_section "Updating ${PROJECT_NAME}"

	chmod +x "${TARGET_DIR}/install.sh"

	if [ ! -d "${TARGET_DIR}/.git" ]; then
	    	log_error "Target directory is not a git repo, cannot update"
	    	exit 1
	fi
	local system="${DOTFILE_SYSTEM:-}"
	if [ -z "$system" ]; then
	    	log_error "DOTFILE_SYSTEM not set in environment"
	    	exit 1
	fi

	log_info "Detected install distro: $system"
	log_info "Pulling latest changes (auto-stashing local edits)..."
	
	git -C "$TARGET_DIR" pull --autostash
	
	if ! git -C "$TARGET_DIR" --no-pager diff --check; then
	    	log_warning "Merge conflicts detected after update — reverting to pre-pull state"
	    	git -C "$TARGET_DIR" reset --merge
	    	log_error "Update aborted due to conflicts. Your local changes are safe but the update was not applied."
	    	exit 1
	fi
	
	log_success "Repo updated cleanly"	
	
	IS_UPDATE=true
	
	read -rp "Check for updates to optional apps (Hyprshot, Walk, Zen, Obsidian, VSCode)? (y/n) [n]: " update_optional
	update_optional=${update_optional:-n}
	
	if [[ $update_optional =~ ^[Yy]$ ]]; then
	    	SKIP_OPTIONAL_INSTALLS=false
	    	log_info "Optional apps will be checked"
	else
	    	SKIP_OPTIONAL_INSTALLS=true
	    	log_info "Optional apps will be skipped"
	fi

	case "$system" in
	    	debian)
	    	    	IS_DEBIAN=true	
	    	    	debianInstall
	    	;;
	    	arch)
	    	    	IS_ARCH=true
	    	    	archInstall
	    	;;
	    	fedora)
	    	    	IS_FEDORA=true
	    	    	fedoraInstall
	    	;;
	    	*)
	    	    	log_error "Unknown DOTFILE_SYSTEM value: $system"
	    	    	exit 1
	    	;;
	esac

	chmod +x "${TARGET_DIR}/install.sh"

	log_section "Updating/Installation Done."
	log_success "Update complete — re-login to apply any config changes"
}