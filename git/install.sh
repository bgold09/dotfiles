#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"
source $DOTFILES_REPO/script/helpers.bash

curr="$(pwd)"
name='git'

place_files() {
	ln -f gitconfig $HOME/.gitconfig
}

e_header "Installing $name configration..."
place_files
e_success "$name confguration installed"
exit 0
