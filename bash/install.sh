#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"
source $DOTFILES_REPO/script/helpers.bash

curr="$(pwd)"
name="$(basename $(pwd))"

place_files() {
	rm -f $HOME/.bash
	ln -s $curr $HOME/.bash
	rm -f $HOME/.bashrc 
	ln bashrc $HOME/.bashrc
	rm -f $HOME/.bash_profile
	ln bash_profile $HOME/.bash_profile
	rm -f $HOME/.profile
	ln profile $HOME/.profile
}

info "Installing $name configuration..."
place_files
success "$name configuration installed"
exit 0
