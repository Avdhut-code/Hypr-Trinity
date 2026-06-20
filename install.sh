#!/bin/bash

set -euo pipefail

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m'

### THERE IS SOME ISSUE WITH THIS 
ORIGINAL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

### CHANGE IT ###
### CHNAGE THIS AS WELL AS CHANGE IN THE WHOLE REPO TO AVOID THE TYPO ERROR OF 'file not found'
PROJECT_NAME="LinuxMintHyprlandConfig"

### THIS WILL CHANGE OVER TIME
VERSION="0.0.1"
FEDORA_MIN_UNSUPPORTED_VERSION=43 

TARGET_DIR="${HOME}/.local/share/${PROJECT_NAME}"
BACKUP_CONFIG_LOCATION="${TARGET_DIR}/backupConfigs"

SKIP_OPTIONAL_INSTALLS=false
AUTOMATIC_OPTIONAL_INSATALL=false

SYMLINK_INSTALL_TOOL=false

IS_DEBIAN=false
IS_ARCH=false
IS_FEDORA=false

IS_INSTALL=false
IS_UPDATE=false

log_info() {
  	echo -e "${BLUE}[INFO]${NC} $*"
}

log_success() {
  	echo -e "${GREEN}[✓]${NC} $*"
}

log_warning() {
  	echo -e "${YELLOW}[!]${NC} $*"
}

log_error() {
  	echo -e "${RED}[✗]${NC} $*" >&2
}

log_section() {
  	echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  	echo -e "${BLUE}$*${NC}"
  	echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}	

exit_with_error() {
  	log_error "$1"
  	exit 1
}

checkIfDebian() {
	if [ ! -f "${ORIGINAL_DIR}/README.md" ] || [ ! -d "${ORIGINAL_DIR}/config" ]; then
		exit_with_error "Script must be run from repository root directory"
	fi

	log_success "Running from correct directory: ${ORIGINAL_DIR}"

	if ! grep -q "^ID=.*debian\|^ID=linuxmint" /etc/os-release 2>/dev/null; then
		exit_with_error "This script only supports Debian-based systems (Linux Mint, Ubuntu, etc.)"
	fi
	
	if ! grep -q "DOTFILE_SYSTEM=" "${HOME}/.bashrc"; then
		echo 'export DOTFILE_SYSTEM="debian"' >> "${HOME}/.bashrc"
		log_success "DOTFILE_SYSTEM=debian written to .bashrc"
	fi

	log_success "System is Debian-based"
}

checkIfArch() {
	if [ ! -f "${ORIGINAL_DIR}/README.md" ] || [ ! -d "${ORIGINAL_DIR}/config" ]; then
		exit_with_error "Script must be run from repository root directory"
	fi

	log_success "Running from correct directory: ${ORIGINAL_DIR}"

	if ! grep -q "^ID=.*arch\|^ID=manjaro" /etc/os-release 2>/dev/null; then
		exit_with_error "This script only supports Arch-based systems (Arch Linux, Manjaro, etc.)"
	fi
	
	if ! grep -q "DOTFILE_SYSTEM=" "${HOME}/.bashrc"; then
		echo 'export DOTFILE_SYSTEM="arch"' >> "${HOME}/.bashrc"
		log_success "DOTFILE_SYSTEM=arch written to .bashrc"
	fi

	log_success "System is Arch-based"
}

checkIfFedora() {
	if [ ! -f "${ORIGINAL_DIR}/README.md" ] || [ ! -d "${ORIGINAL_DIR}/config" ]; then
		exit_with_error "Script must be run from repository root directory"
	fi

	log_success "Running from correct directory: ${ORIGINAL_DIR}"

	if ! grep -q "^ID=.*fedora" /etc/os-release 2>/dev/null; then
		exit_with_error "This script only supports Fedora-based systems"
	fi
	
	if ! grep -q "DOTFILE_SYSTEM=" "${HOME}/.bashrc"; then
		echo 'export DOTFILE_SYSTEM="fedora"' >> "${HOME}/.bashrc"
		log_success "DOTFILE_SYSTEM=fedora written to .bashrc"
	fi

    	local fedora_version
    	fedora_version=$(grep "^VERSION_ID=" /etc/os-release | cut -d= -f2)

    	if [ "$fedora_version" -ge "$FEDORA_MIN_UNSUPPORTED_VERSION" ] 2>/dev/null; then
    	    	log_warning "Fedora ${fedora_version} detected — Hyprland support via COPR may be limited"
    	    	log_warning "Check https://copr.fedorainfracloud.org/coprs/sdegler/hyprland/ before continuing"
    	fi

    	log_success "System is Fedora-based"
}

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
        	gnome-terminal \
		evince \
		xed \
		nemo \
		mpv \
		curl \
		rsync
	
    	sudo apt autoremove -y
    	sudo apt clean
}

installPackagesArch() {
    	sudo pacman -Syu --noconfirm
   	sudo pacman -S --noconfirm \
        	git ddcutil btop htop libnotify pavucontrol \
        	wireplumber playerctl wofi swaybg \
        	gnome-terminal evince gedit nemo mpv curl \
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
		rsync
}

installPackagesFedora() {
    	sudo dnf update -y
	sudo dnf copr enable sdegler/hyprland -y  	
	sudo dnf install -y \
        	git ddcutil btop htop libnotify pavucontrol \
        	wireplumber playerctl wofi swaybg \
        	gnome-terminal evince xed nemo mpv curl \
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
		rsync

	sudo dnf clean all 
}

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
	ln -sfn "${TARGET_DIR}/config/hypr" 	"${HOME}/.config/"
	ln -sfn "${TARGET_DIR}/config/waybar" 	"${HOME}/.config/"
	ln -sfn "${TARGET_DIR}/config/wofi" 	"${HOME}/.config/"
	ln -sfn "${TARGET_DIR}/config/btop" 	"${HOME}/.config/"
	ln -sfn "${TARGET_DIR}/config/swaync" 	"${HOME}/.config/"

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

	mkdir -p "${HOME}/.themes"

	ln -sfn "${TARGET_DIR}/theme/gtkThemes/Graphite-Dark" "${HOME}/.themes/"

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
		innerHyprshotInstall
		return
	fi

	echo "  [1] Auto install from GitHub"
	echo "  [2] Manual install (show instructions)"
	echo "  [3] Skip"
	read -rp "Select option [1/2/3]: " choice

	case "$choice" in
	1)
		innerHyprshotInstall		
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
		fi
		if [ "$IS_ARCH" == true ]; then
		        command -v yay &>/dev/null && yay -S --noconfirm obsidian || innerObsidianInstall
		fi
		if [ "$IS_FEDORA" == true ]; then
			innerObsidianInstall "fedora"
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
		fi

		if [ "$IS_ARCH" == true ]; then
			if command -v yay &>/dev/null; then	
				log_info "Downloading obsidian"
				yay -S --noconfirm obsidian
			else
				log_warning "yay not found — install obsidian from AUR manually"
			fi
		fi

		if [ "$IS_FEDORA" == true ]; then
			innerObsidianInstall "fedora" 
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

vscodeThemeInstall(){
	local settings="${HOME}/.config/Code/User/settings.json"

	if command -v code &>/dev/null; then
		log_info "Now installing vscode theme"
		
		mkdir -p "${HOME}/.vscode/extensions"

		code --install-extension 'viktorqvarfordt.vscode-pitch-black-theme' 2>/dev/null && log_success "VSCode Pitch Black theme installed" || log_warning "Failed to install VSCode Pitch Black theme"	

		mkdir -p "$(dirname "$settings")"

		if [ -f "$settings" ]; then
			sed -i 's/"workbench.colorTheme": ".*"/"workbench.colorTheme": "Pitch Black"/' "$settings"
		else
			echo '{ "workbench.colorTheme": "Pitch Black" }' > "$settings"
		fi		
	fi
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

debianInstall(){
	if [ "${IS_INSTALL}" == true ]; then
		log_section "Pre-Installation Checks"
		checkIfDebian
	fi 

	log_section "System Package Installation"
	installPackagesDebian

	log_section "Relocating Dotfiles Suite"
	repoCopyToTarget

	log_section "Permissions & Configuration"
	takePermissions

	log_section "Backing up original configs"
	backupConfigs
	
	log_section "Creating Symlinks"
	simlinkCreate

	if [ "${IS_UPDATE}" == true ] || [ "${IS_INSTALL}" == true ] ; then
		log_section "Configuring .bashrc"
		bashAppend
	fi 

	log_section "Applying GTK Theme"
	themeApply

	if  [ "$SKIP_OPTIONAL_INSTALLS" == true ]; then
		log_info "Optional app installations will be skipped"
	else
		log_section "Optional Installations"
		optionalInstallAll
	fi	
}

archInstall(){
	if [ "${IS_INSTALL}" == true ]; then
		log_section "Pre-Installation Checks"
		checkIfArch
	fi 

	log_section "System Package Installation"
	installPackagesArch

	log_section "Relocating Dotfiles Suite"
	repoCopyToTarget

	log_section "Permissions & Configuration"
	takePermissions

	log_section "Backing up original configs"
	backupConfigs
	
	log_section "Creating Symlinks"
	simlinkCreate

	if [ "${IS_UPDATE}" == true ] || [ "${IS_INSTALL}" == true ] ; then
		log_section "Configuring .bashrc"
		bashAppend
	fi  

	log_section "Applying GTK Theme"
	themeApply

	if  [ "$SKIP_OPTIONAL_INSTALLS" == true ]; then
		log_info "Optional app installations will be skipped"
	else
		log_section "Optional Installations"
		optionalInstallAll
	fi	
}

fedoraInstall(){
	if [ "${IS_INSTALL}" == true ]; then
		log_section "Pre-Installation Checks"
		checkIfFedora
	fi 
	
	log_section "System Package Installation"
	installPackagesFedora

	log_section "Relocating Dotfiles Suite"
	repoCopyToTarget

	log_section "Permissions & Configuration"
	takePermissions

	log_section "Backing up original configs"
	backupConfigs

	log_section "Creating Symlinks"
	simlinkCreate

	if [ "${IS_UPDATE}" == true ] || [ "${IS_INSTALL}" == true ] ; then
		log_section "Configuring .bashrc"
		bashAppend
	fi 

	log_section "Applying GTK Theme"
	themeApply

	if  [ "$SKIP_OPTIONAL_INSTALLS" == true ]; then
		log_info "Optional app installations will be skipped"
	else
		log_section "Optional Installations"
		optionalInstallAll
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
	
	rm -rf "${HOME}/.themes/Graphite-Dark"
	
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
	
	if [ ! -d "${TARGET_DIR}/.git" ]; then
	    	log_error "Target directory is not a git repo, cannot update"
	    	log_info "Re-clone the repo to ${TARGET_DIR} and re-run install first"
	    	exit 1
	fi
	
	local system="${DOTFILE_SYSTEM:-}"
	
	if [ -z "$system" ]; then
	    	log_error "DOTFILE_SYSTEM not set in environment"
	    	log_info "Run: source ~/.bashrc  then try again"
	    	log_info "Or re-run install.sh with your distro flag to set it"
	    	exit 1
	fi
	
	log_info "Detected install distro: $system"
	log_info "Pulling latest changes..."
	
	cd "$TARGET_DIR"
	git pull
	cd - >/dev/null
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
	log_success "Update complete — re-login to apply any config changes"
}

installProceed(){
	echo "This script will:"
	echo "	• Check what distrobution you installing this onto"
	echo "  • Install system packages (requires sudo)"
	echo "  • Relocate suite to ~/.local/share/${PROJECT_NAME}"
	echo "  • Create symlinks in ~/.local/bin (user-local, no sudo)"
	echo "	• Moves the original Config folders to 'backupFolder' (folder from previous setup)"
	echo "  • Create symlinks in ~/.config (user-local, no sudo)"
	echo "  • Append to .bashrc with safe environment variables"
	echo "  • Apply GTK theme with gesttings based on your desktop enviourment"
	echo "  • Ask you to permission to install based on your desktop enviourment"
	echo "    - [ If you used the '--no-optional' tag, will skip over the permission ]"
	echo ""
	
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
	    	
		ln -sfn "${TARGET_DIR}/install.sh" "${HOME}/.local/bin/updateproject"
	   	
		chmod +x "${TARGET_DIR}/install.sh"
		
		log_success "updateproject symlinked to ~/.local/bin"
	fi
}
main(){
	if [ -z "$1" ]; then
		echo "Error: first argument cannot be empty."
		echo "Usage: $0 [--help] [--debian | --arch | --fedora] [--no-optional]"
		exit 1
	fi

	while [[ $# -gt 0 ]]; do
	case "$1" in
		-h|--help)
		echo "Usage: $0  [--yes-optional] [--no-optional] [--debian] | [--arch] | [--fedora] [--version] [--help]"
		echo ""
		echo "[ Distro tag ]"
		echo "  --debian	-d	Install packages for Debian-based systems (apt)"
		echo "  --arch  	-a	Install packages for Arch-based systems (pacman)"
		echo "  --fedora	-f	Install packages for Fedora-based systems (dnf)"
		echo ""
		echo "  --yes-optional    -y	Used before 'Distro tag' to install all optional apps installations"
		echo "  --no-optional     -n	Used before 'Distro tag' to skip optional apps installations"
		echo "  --restore         -r	Remove symlinks and restore original configs"
		echo "  --update          -u	Updates the project but no backup rn"
		echo "  --version         -v	Show projects current version and exit"
		echo "  --help            -h	Show this help message and exit"
		echo ""
		exit 0
		;;
		-v|--version)
			echo "${PROJECT_NAME} by 'Avdhut-code' is on version : ${RED}v$VERSION${NC} ."
			exit 0
		;;
		-n|--no-optional)
		        SKIP_OPTIONAL_INSTALLS=true
			shift
		;;	
		-y|--yes-optional)
		        AUTOMATIC_OPTIONAL_INSATALL=true
			shift
		;;		
		-u|--update)
			updateProject
			shift
		;;
		-r|--restore)
			restoreConfigs
			shift
		;;
		-d|--debian)
			IS_DEBIAN=true
			IS_INSTALL=true
			installProceed
			debianInstall
			shift
		;;
		-a|--arch)
			IS_ARCH=true
			IS_INSTALL=true
			installProceed
			archInstall
			shift
		;;
		-f|--fedora)
			IS_FEDORA=true
			IS_INSTALL=true
			installProceed
			fedoraInstall
			shift
		;;

		-*|*)
			echo "Error: Unknown option $1" >&2
			exit 1
		;;
		esac
	done
	
	if [ "${IS_INSTALL}" == true ]; then	
		log_section " Install Done."

		read -rp "Symlink install.sh as 'updateproject' command for easy future updates? (y/n) [y]: " link_tool

		link_tool=${link_tool:-y}

		if [[ $link_tool =~ ^[Yy]$ ]]; then
			SYMLINK_INSTALL_TOOL=true
			updateToolSimlink
		fi
	fi

	log_success "Just run this now Command : source ~/.bashrc " 
	log_success "Installation completed successfully!"
}

main "$@"