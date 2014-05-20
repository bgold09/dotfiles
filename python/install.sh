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
		[ -e "~/.pythonrc.py" ] && cp ~/.pythonrc.py $backup/pythonrc.py
	fi

	ln -f pythonrc.py $HOME/.pythonrc.py
}

info "Installing $name configuration..."
place_files $1
success "$name configuration installed"
exit 0
