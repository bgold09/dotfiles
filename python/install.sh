#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"
source $DOTFILES_REPO/script/helpers.bash

curr="$(pwd)"
name="$(basename $(pwd))"

place_files() {
	ln -f pythonrc.py $HOME/.pythonrc.py
}

info "Installing $name configuration..."
place_files
success "$name configuration installed"
exit 0
