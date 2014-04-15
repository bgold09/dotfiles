#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"
source $DOTFILES_REPO/system/helpers.bash

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

e_header "Installing $name configration..."
place_files
e_success "$name confguration installed"
exit 0
