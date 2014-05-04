#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"
source $DOTFILES_REPO/script/helpers.bash

curr="$(pwd)"
name="$(basename $(pwd))"

place_files() {
	for file in $(ls -I 'install.sh'); do
		ln -f $file $HOME/.$file
	done
}

info "Installing $name configuration..."
if [ $(uname -o) = "Cygwin" ]; then 
	place_files
	success "$name configuration installed"
else 
	warn "not on a Windows system"
fi

exit 0
