#!/bin/bash

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

	log_section "Installing Fonts"
	fontInstall

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

	log_section "Installing Fonts"
	fontInstall


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

	log_section "Installing Fonts"
	fontInstall


	if  [ "$SKIP_OPTIONAL_INSTALLS" == true ]; then
		log_info "Optional app installations will be skipped"
	else
		log_section "Optional Installations"
		optionalInstallAll
	fi
}