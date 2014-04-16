#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"
source $DOTFILES_REPO/script/helpers.bash

curr="$(pwd)"
name="$(basename $(pwd))"

place_files() {
	ln -f vimrc $HOME/.vimrc
	rm -f $HOME/.vim         # remove any symlink to vim config directory
	ln -s $curr $HOME/.vim
}

info "Installing $name configration..."
place_files
success "$name confguration installed"
exit 0
