#!/bin/bash

set -e

FLAG=''
if ! command -v alacritty &>/dev/null; then
  echo "Error: alacritty is not installed or not in PATH." >&2
  exit 1
fi

if ! command -v btop &>/dev/null; then
  echo "Error: btop is not installed or not in PATH." >&2
  exit 1
fi

if btop --help | grep -q -- "--force-utf"; then
    FLAG="--force-utf"
else
    FLAG="--utf-force"
fi

alacritty --class custombtoplauncher --title "btop Monitor" -e sh -c "btop ${FLAG}"