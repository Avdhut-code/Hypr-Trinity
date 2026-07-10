#!/bin/bash 

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
			echo '{ "workbench.colorTheme": "Pitch Black" }' >>"$settings"
			echo '{ "editor.fontFamily": "JetBrainsMono Nerd Font" }' >> "$settings"
		fi		
	fi
}

obsidianThemeInstall(){
	read -r -e -p "Enter the path to your Obsidian Vault: " filepath
	local obsidian_dir="$filepath"

	if [ ! -d "${obsidian_dir}/.obsidian" ]; then
		log_warning "Not a valid Obsidian Vault path. Skipping Obsidian theme installation."
		return
	fi

        if [ -z "${obsidian_dir}" ]; then
                log_warning "No path provided. Skipping Obsidian theme installation."
                return
        fi

        local obsidian_theme_dir="${obsidian_dir}/.obsidian/themes"
        local obsidian_appearance_file="${obsidian_theme_dir}/appearance.json"
        
        if [ -d "${obsidian_dir}" ]; then
                log_info "Installing Obsidian theme..."
                mkdir -p "${obsidian_theme_dir}"
                touch "${obsidian_appearance_file}"
                
                if [ ! -f "${TARGET_DIR}/themes/Obsidian/pitchBlack" ]; then
                        ln -sfn "${TARGET_DIR}/themes/Obsidian/pitchBlack" "${obsidian_theme_dir}/pitchBlack"

                        sed -i \
                        -e 's/"theme":.*/"theme": "obsidian",/' \
                        -e 's/"cssTheme":.*/"cssTheme": "pitchBlack",/' \
                        -e 's/"interfaceFontFamily":.*/"interfaceFontFamily": "JetBrainsMono Nerd Font",/' \
                        -e 's/"accentColor":.*/"accentColor": "#f5f4f4"/' \
                        "${obsidian_appearance_file}"
                        
                        log_success "Obsidian Pitch Black theme installed"
                else
                        log_warning "Obsidian Pitch Black theme already exists, skipping."
                fi
        else
                log_warning "Obsidian config directory not found, skipping theme installation."
        fi
}

# WILL DO THIS LATER RN IN HURRY

# gtkThemesInstall() {
#         log_section "Installing Themes"
#         ### install gtk themes
# }