#!/bin/bash 

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m'

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

refrenceLink() {
    	local text="$1"
    	local url="$2"

    	local start="${text%%<*}"
    	local rest="${text#*<}"
    	local link_text="${rest%%>*}"
    	local end="${rest#*>}"

	printf '%b' "${start}\e]8;;${url}\a${link_text}\e]8;;\a${end}"
}