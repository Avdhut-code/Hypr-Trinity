#!/bin/bash 

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