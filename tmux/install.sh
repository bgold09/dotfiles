#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"
source $DOTFILES_REPO/script/helpers.bash

curr="$(pwd)"
name="$(basename $(pwd))"

place_files() {
	rm -f $HOME/.tmux
	ln -s $curr $HOME/.tmux
	ln -f tmux.conf $HOME/.tmux.conf
}

info "Installing $name configuration..."
place_files
success "$name configuration installed"
exit 0
