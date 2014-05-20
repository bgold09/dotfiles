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
		[ -e "$HOME/.vimrc" ] && cp ~/.vimrc $backup/vimrc
		if [ -e "$HOME/.vim" ]; then
			mkdir $backup/vim-files && cp -r ~/.vim/* $backup/vim-files
		fi
	fi
	rm -f $HOME/.vimrc
	ln vimrc $HOME/.vimrc
	rm -f $HOME/.vim         # remove any symlink to vim config directory
	ln -s $curr $HOME/.vim
}

info "Installing $name configuration..."
place_files $1
success "$name configuration installed"
exit 0
