#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"
source $DOTFILES_REPO/script/helpers.bash

curr="$(pwd)"
name="$(basename $(pwd))"

place_files() {
	if [ -n "$1" ]; then
		mkdir "$1/$name"
		[ -e "$HOME/.tmux.conf" ] && cp $HOME/.tmux.conf $1/$name
	fi
	
	ln -f tmux.conf $HOME/.tmux.conf
}

info "Installing $name configuration..."
place_files $1
success "$name configuration installed"
exit 0
