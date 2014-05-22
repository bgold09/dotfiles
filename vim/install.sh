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

	ln -fs "$(readlink -f vimrc)" $HOME/.vimrc
	rm -rf $HOME/.vim         # remove any symlink to vim config directory
	ln -s $curr $HOME/.vim
}

vundle_clone() {
	[ -z "$VUNDLE_URI" ] && VUNDLE_URI="https://github.com/gmarik/vundle.git"

	if [ ! -e "$HOME/.vim/bundle/vundle" ]; then
		git clone $VUNDLE_URI "$HOME/.vim/bundle/vundle" >> /dev/null 2>&1
		if [ ! $? -eq 0 ]; then
			fail "vim install failed, unable to clone vundle"
			exit 1
		fi
	fi
}

info "Installing $name configuration..."
place_files $1
vundle_clone
success "$name configuration installed"
exit 0
