#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"
source $DOTFILES_REPO/script/helpers.bash

curr="$(pwd)"
name="$(basename $(pwd))"

place_files() {
	if [ -n "$1" ]; then
		backup="$1/$name"
		mkdir $backup
		[ -e "$HOME/.gitconfig" ] && cp ~/.gitconfig $backup/gitconfig
		if [ -e "$HOME/.gitfiles" ]; then 
			mkdir $backup/gitfiles && cp ~/.gitfiles/* $backup/gitfiles
		fi
	fi

	ln -f gitconfig $HOME/.gitconfig
	rm -f $HOME/.gitfiles
	ln -s $curr $HOME/.gitfiles
}

info "Installing $name configuration..."
place_files $1
success "$name configuration installed"
exit 0
