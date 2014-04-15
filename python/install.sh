#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"
source $DOTFILES_REPO/system/helpers.bash

curr="$(pwd)"
name="$(basename $(pwd))"

place_files() {
	ln -f pythonrc.py $HOME/.pythonrc.py
}

info "Installing $name configration..."
place_files
success "$name confguration installed"
exit 0
