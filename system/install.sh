#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"
source $DOTFILES_REPO/script/helpers.bash

curr="$(pwd)"
name="$(basename $(pwd))"

place_files() {
	[ -n "$1" ] && mkdir "$1/$name"

	for file in $(ls -I 'install.sh'); do
		if [ -n "$1" ] && [ -e "$HOME/.$file" ] ; then
			cp $file "$1/$name/$file"
		fi

		ln -fs "$(readlink -f $file)" $HOME/.$file
	done
}

info "Installing $name configuration..."
place_files $1
success "$name configuration installed"
exit 0
