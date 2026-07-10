#!/bin/bash

yayInstall() {
	if command -v yay &>/dev/null; then
		log_success "yay already installed"
		return
	fi
	
	log_info "Installing yay (AUR helper)..."
	sudo pacman -S --noconfirm git base-devel
	git clone https://aur.archlinux.org/yay.git /tmp/yay
	cd /tmp/yay && makepkg -si --noconfirm
	cd - && rm -rf /tmp/yay
	
	log_success "yay installed"
}

innerHyprshotinstall(){
	log_info "Cloning Hyprshot..."
	if git clone https://github.com/Gustash/hyprshot.git "${HOME}/Hyprshot" 2>/dev/null; then
		chmod +x "${HOME}/Hyprshot/hyprshot"
		mkdir -p "${HOME}/.local/bin"
		ln -sfn "${HOME}/Hyprshot/hyprshot" "${HOME}/.local/bin/hyprshot"
		log_success "Hyprshot installed at: ${HOME}/Hyprshot"
	else
		log_warning "Failed to clone Hyprshot"
	fi
}

hyprshotInstall() {
	if [ ! -t 0 ]; then
		log_info "Non-interactive shell detected, skipping."
		return
	fi

	if ! ${IS_UPDATE}; then 
		if command -v hyprshot &>/dev/null; then
			log_success "hyprshot is already installed, skipping."
			return
		fi
	fi

	if [ "${AUTOMATIC_OPTIONAL_INSATALL}" == true ] ; then
		innerHyprshotinstall
		return
	fi

	echo "  [1] Auto install from GitHub"
	echo "  [2] Manual install (show instructions)"
	echo "  [3] Skip"
	read -rp "Select option [1/2/3]: " choice

	case "$choice" in
	1)
		innerHyprshotinstall		
	;;
	2)
      	echo """
		Manual Hyprshot Installation:
			1. git clone https://github.com/Gustash/hyprshot.git ~/Hyprshot

			2. chmod +x ~/Hyprshot/hyprshot
			
			3. mkdir -p ~/.local/bin && ln -s ~/Hyprshot/hyprshot ~/.local/bin/hyprshot
			
			4. hyprshot --help 
	"""
      	;;
    	3|*)
      		log_info "Hyprshot installation skipped"
      	;;
  	esac
}

innerWalkInstall(){
	if git clone https://github.com/antonmedv/walk.git "${HOME}/walk" 2>/dev/null; then
		log_info "Running walk install script..."
		if bash "${HOME}/walk/install.sh"; then
			log_success "Walk installed successfully"
		else
			log_warning "Walk install script failed"
		fi
	else
		log_warning "Failed to clone walk"
	fi
}

walkInstall() {
	if ! ${IS_UPDATE}; then
		if command -v walk &>/dev/null; then
			log_success "Walk is already installed, skipping."
			return
		fi
	fi

	if [ "${AUTOMATIC_OPTIONAL_INSATALL}" == true ] ; then
		innerWalkInstall
		return
	fi

	echo "  [1] Auto install from GitHub"
	echo "  [2] Manual install (show instructions)"
	echo "  [3] Skip"
	read -rp "Select option [1/2/3]: " walkChoice
	
	case "$walkChoice" in
	1)
		innerWalkInstall
	;;
	2)
      	echo """
		Manual Walk Installation:
			1. git clone https://github.com/antonmedv/walk.git ~/walk

			2. chmod +x ~/walk/install.sh
			
			3. bash ~/walk/install.sh
	"""
	;;
	3|*)
		log_info "Walk installation skipped"
	;;
	esac

}

innerZenInstall(){
	local tarball_url="https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-x86_64.tar.xz"
	local tarball_path="/tmp/zen.linux-x86_64.tar.xz"
	local install_dir="${HOME}/zen-browser"
	log_info "Downloading Zen Browser..."
	if curl -L "$tarball_url" -o "$tarball_path"; then

		log_info "Extracting..."
		mkdir -p "$install_dir"
		tar -xf "$tarball_path" -C "$install_dir" --strip-components=1
		log_info "Creating symlink..."
		ln -sfn "$install_dir/zen" "${HOME}/.local/bin/zen"
		rm "$tarball_path"
		log_success "Zen Browser installed at: $install_dir"
		
		else
			log_warning "Failed to download Zen Browser"
		fi			
}
	
zenInstall() {

	if ! ${IS_UPDATE}; then 
		if command -v zen &>/dev/null; then
			log_success "Zen Browser is already installed, skipping."
			return
		fi
	fi

	if [ "$AUTOMATIC_OPTIONAL_INSATALL" == true ]; then 		
		if [ "$IS_ARCH" == true ]; then
		        command -v yay &>/dev/null && yay -S --noconfirm zen-browser-bin || innerZenInstall
		else 
			innerZenInstall
		fi	
		
		return	
	fi

	echo "  [1] Auto install from GitHub"
	echo "  [2] Manual install (show instructions)"
	echo "  [3] Skip"
	read -rp "Select option [1/2/3]: " choice
	
	case "$choice" in
	1)	
		if [ "$IS_DEBIAN" == true ]; then
			innerZenInstall
		fi
	
		if [ "$IS_ARCH" == true ]; then
   			if command -v yay &>/dev/null; then
        			yay -S --noconfirm zen-browser-bin
    			else
        			log_warning "yay not found — falling back to tarball install"
				innerZenInstall
			fi
    		fi

		if [ "$IS_FEDORA" == true ]; then
			innerZenInstall
		fi

	;;
	2)
	echo """
		Manual Zen Browser Installation:
			1. Download:
			"curl -L https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-x86_64.tar.xz -o /tmp/zen.tar.xz"

			2. Extract:
			"mkdir -p ~/.local/share/zen-browser"
			"tar -xf /tmp/zen.tar.xz -C ~/.local/share/zen-browser --strip-components=1"

			3. Symlink the binary "ln -sfn ~/.local/share/zen-browser/zen ~/.local/bin/zen"

			4. Verify by running "zen --version"
	"""
	;;
	3|*)
		log_info "Zen Browser installation skipped"
	;;
	esac
}

innerObsidianInstall(){
	local version
	version=$(curl -s https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest \
	    | grep '"tag_name"' | cut -d'"' -f4 | tr -d 'v')
	
	case "$1" in
		debian)
			local pkg_url="https://github.com/obsidianmd/obsidian-releases/releases/download/v${version}/obsidian_${version}_amd64.deb"
			local pkg_path="/tmp/obsidian_${version}.deb"
			log_info "Downloading obsidian"
			curl -L "$pkg_url" -o "$pkg_path" 
			sudo apt install -y "$pkg_path" 
			rm "$pkg_path"
		;;
		fedora)
			local pkg_url="https://github.com/obsidianmd/obsidian-releases/releases/download/v${version}/Obsidian-${version}.AppImage"
			local pkg_path="${TARGET_DIR}/apps/obsidian_${version}.AppImage"
			log_info "Downloading obsidian"
			mkdir -p "${TARGET_DIR}/apps"
			curl -L "$pkg_url" -o "$pkg_path"
			chmod +x "$pkg_path"
			ln -sfn "$pkg_path" "$HOME/.local/bin/obsidian"
			touch "${TARGET_DIR}/apps/obsidian.desktop"
			echo """ [Desktop Entry]
				Name=Obsidian
				Exec=obsidian
				Terminal=false
				Type=Editor
				Categories=Editor;Development;
				""" > "${TARGET_DIR}/apps/obsidian.desktop"
			mkdir -p "$HOME/.local/share/applications"
			ln -sfn "${TARGET_DIR}/apps/obsidian.desktop" "$HOME/.local/share/applications/obsidian.desktop"
			log_success "Obsidian AppImage installed at: $pkg_path"
		;;
		*)
			log_error "Not the correct argument" 
		;;
	esac
}

obsidianInstall() {
	if ! ${IS_UPDATE}; then 
		if command -v obsidian &>/dev/null; then
			log_success "obsidian is already installed, skipping."
			return
		fi
	fi 

	if [ "$AUTOMATIC_OPTIONAL_INSATALL" == true ]; then 		
		if [ "$IS_DEBIAN" == true ]; then
			innerObsidianInstall "debian"
			obsidianThemeInstall
		fi
		if [ "$IS_ARCH" == true ]; then
		        command -v yay &>/dev/null && yay -S --noconfirm obsidian || innerObsidianInstall 
			obsidianThemeInstall
		fi
		if [ "$IS_FEDORA" == true ]; then
			innerObsidianInstall "fedora"
			obsidianThemeInstall
		fi	
		
		return	
	fi

	echo "  [1] Auto install from GitHub"
	echo "  [2] Manual install (show instructions)"
	echo "  [3] Skip"
	read -rp "Select option [1/2/3]: " obsidianChoice
	
	
	case "$obsidianChoice" in
	1)	
		if [ "$IS_DEBIAN" == true ]; then
			innerObsidianInstall "debian" 	
			obsidianThemeInstall
		fi

		if [ "$IS_ARCH" == true ]; then
			if command -v yay &>/dev/null; then	
				log_info "Downloading obsidian"
				yay -S --noconfirm obsidian
				obsidianThemeInstall
			else
				log_warning "yay not found — install obsidian from AUR manually"
			fi
		fi

		if [ "$IS_FEDORA" == true ]; then
			innerObsidianInstall "fedora" 
			obsidianThemeInstall
		fi

		log_success "Obsidian installed"
	;;
	2)
	echo """
		Manual Obsidian Installation:
			1. got to https://obsidian.md/download

			2. download the appropriate package for you system
			
			3. got to the download directory and run "sudo apt install ./obsidian_*.deb"
			
			4. install it with "sudo apt install ./path/to/obsidian_*.deb"
			
			5. remove the .deb file after installation with "rm ./path/to/obsidian_*.deb"
			
			6. Now you can add the obsidian dark theme to your "VaultName/.obsidian/themes/"
	"""
	;;
	3|*)
		log_info "Obsidian installation skipped"
	;;
	esac
}

innerVscodeInstall(){
	case "$1" in
		debian)
			log_info "Downloading Vscode"
			local pkg_url="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
			local pkg_path="/tmp/vscode.deb"
			curl -L "$pkg_url" -o "$pkg_path" 
			sudo apt install -y "$pkg_path" 
			rm "$pkg_path"
			vscodeThemeInstall	
		;;
		fedora)
			local pkg_url="https://code.visualstudio.com/sha/download?build=stable&os=linux-rpm-x64"
			local pkg_path="/tmp/vscode.rpm"
			curl -L "$pkg_url" -o "$pkg_path" 
			sudo dnf install -y "file://${pkg_path}" 
			rm "$pkg_path"
			vscodeThemeInstall	
		;;
		*)
			log_error "Unavailable the correct argument" 
		;;
	esac
}

vscodeInstall() {
	if ! ${IS_UPDATE}; then 
		if command -v code &>/dev/null; then
			log_success "vscode is already installed, skipping."
			return
		fi
	fi 

	if [ "$AUTOMATIC_OPTIONAL_INSATALL" == true ]; then 		
		if [ "$IS_DEBIAN" == true ]; then
			innerVscodeInstall "debian"
		fi
		if [ "$IS_ARCH" == true ]; then
		        command -v yay &>/dev/null && yay -S --noconfirm visual-studio-code-bin || innerVscodeInstall
		fi
		if [ "$IS_FEDORA" == true ]; then
			innerVscodeInstall "fedora"
		fi	
		
		return	
	fi

	echo "  [1] Auto install from GitHub"
	echo "  [2] Manual install (show instructions)"
	echo "  [3] Skip"
	read -rp "Select option [1/2/3]: " vscodeChoice

	case "$vscodeChoice" in
	1)
		if [ "$IS_DEBIAN" == true ]; then
			innerVscodeInstall "debian"
		fi

		if [ "$IS_ARCH" == true ]; then
			if command -v yay &>/dev/null; then
				log_info "Downloading Vscode"
				yay -S --noconfirm visual-studio-code-bin
			else
				log_warning "yay not found — install VSCode from AUR manually"
			fi
		fi

		if [ "$IS_FEDORA" == true ]; then
			innerVscodeInstall "fedora"
		fi
	;;
	2)
	echo """
		Manual VSCode Installation:
			1. Go to https://code.visualstudio.com/Download
			2. Download the .deb package (x64)
			3. Install it:
			sudo apt install -y ~/Downloads/code_*.deb

			Or via curl:
			1. curl -L "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -o /tmp/vscode.deb
			2. sudo apt install -y /tmp/vscode.deb
			3. code --version
	"""
	;;
	3|*)
		log_info "VSCode installation skipped"
	;;
	esac
}

optionalInstallAll() {	
	log_section "Hyprshot Installation (Optional)"
	hyprshotInstall

	log_section "Walk Installation (Optional)"
	walkInstall
	
	log_section "Zen Browser Installation (Optional)"
	zenInstall
	
	log_section "Obsidian Installation (Optional)"
	obsidianInstall

	log_section "VSCode Installation (Optional)"
	vscodeInstall
}