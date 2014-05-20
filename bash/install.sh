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
		[ -e "$HOME/.bashrc" ] && cp ~/.bashrc $backup/bashrc
		[ -e "$HOME/.bash_profile" ] && cp ~/.bash_profile $backup/bash_profile
		if [ -e "$HOME/.bash" ]; then 
			mkdir $backup/bash-files && cp -r ~/.bash/* $backup/bash-files
		fi
	fi

	rm -f $HOME/.bash
	ln -s $curr $HOME/.bash
	rm -f $HOME/.bashrc 
	ln bashrc $HOME/.bashrc
	rm -f $HOME/.bash_profile
	ln bash_profile $HOME/.bash_profile
}

info "Installing $name configuration..."
place_files $1
success "$name configuration installed"
exit 0
