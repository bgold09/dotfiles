#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"
source $DOTFILES_REPO/script/helpers.bash

curr="$(pwd)"
name="$(basename $(pwd))"

place_files() {
	ln -f gitconfig $HOME/.gitconfig
}

info "Installing $name configration..."
place_files
success "$name confguration installed"
exit 0
