#!/bin/bash

set -euo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
ORIGINAL_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"

PROJECT_NAME="Hypr-Trinity"

# FEDORA DONE !!! , IT SHOWS THE MIDDLE DIGGIT AS I COMPLETE THE ARCH, DEBIAN TESTES THE MIDDDEL DIGGIT WILL MOVE FORWARD WITH ITS TRAILING NUM ALSO CHANGING [VERSION CONCEPT MADE BY ME, I DIDENT ASKED AI FOR IT]
VERSION="0.0.2"

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

source "${ORIGINAL_DIR}/lib/helperFunction.sh"
source "${ORIGINAL_DIR}/lib/distroCheck.sh"
source "${ORIGINAL_DIR}/lib/distroPackages.sh"
source "${ORIGINAL_DIR}/lib/coreInstall.sh"
source "${ORIGINAL_DIR}/lib/optionalApps.sh"
source "${ORIGINAL_DIR}/lib/distroInstall.sh"
source "${ORIGINAL_DIR}/lib/maintenance.sh"

# source "${TARGET_DIR}/lib/[NEWFILE].sh"

main(){
	if [ -z "$1" ]; then
		echo "Error: first argument cannot be empty."
		echo "Usage: $0 [ --help ] [ --yes-optional ] [ --no-optional ] [ --debian | --arch | --fedora ]"
		exit 1
	fi

	while [[ $# -gt 0 ]]; do
	case "$1" in
		-h|--help)
			cat << 'EOF'

Usage: $0  [ --yes-optional ] [ --no-optional ] [ --restore ] [ --update ]
 	   [--debian] | [--arch] | [--fedora] [--version] [--help] 

[ Distro tag ]
  --debian	-d	Install packages for Debian-based systems (apt)
  --arch  	-a	Install packages for Arch-based systems (pacman)
  --fedora	-f	Install packages for Fedora-based systems (dnf)
  
  --yes-optional    -y	Used before 'Distro tag' to install all optional apps installations
  --no-optional     -n	Used before 'Distro tag' to skip optional apps installations
  --restore         -r	Remove symlinks and restore original configs
  --update          -u	Updates the project but no backup rn
  --version         -v	Show projects current version and exit
  --help            -h	Show this help message and exit
		
EOF
		exit 0
		;;
		### NEW FLAG 
		### Add and new tag like '--reinstall' to reinstall corepackages of somthing is broken you can just invoke this to fix that which will just call me DISTROinstall functions based on distro from the bashrc var also add check for if its been running before installing the porject 
		-v|--version)
			refrenceLink "${PROJECT_NAME} by <'Avdhut-code'> is on version : ${RED}v$VERSION${NC}" "https://github.com/Avdhut-code"
			echo ""
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

		read -rp "Symlink install.sh as 'hyprtrinity' command for easy future updates? (y/n) [y]: " link_tool

		link_tool=${link_tool:-y}

		if [[ $link_tool =~ ^[Yy]$ ]]; then
			SYMLINK_INSTALL_TOOL=true
			updateToolSimlink
		fi
	fi

	printf "Just run this command now : %s source ~/.bashrc %s" "${RED}" "${NC}"
	
	log_success "Installation completed successfully!"
}

main "$@"