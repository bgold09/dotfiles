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
		[ -e "$HOME/.base.vimrc" ] && cp ~/.base.vimrc $backup/base.vimrc
		[ -e "$HOME/.gvimrc" ] && cp ~/.gvimrc $backup/gvimrc
		if [ -e "$HOME/.vim" ]; then
			mkdir $backup/vim-files && cp -r ~/.vim/* $backup/vim-files
		fi
	fi

	ln -fs "$(readlink -f base.vimrc)" $HOME/.base.vimrc
	ln -fs "$(readlink -f vimrc)" $HOME/.vimrc
	ln -fs "$(readlink -f gvimrc)" $HOME/.gvimrc
	rm -rf $HOME/.vim         # remove any symlink to vim config directory
	ln -s $curr $HOME/.vim
}

info "Installing $name configuration..."
place_files $1
success "$name configuration installed"
exit 0
