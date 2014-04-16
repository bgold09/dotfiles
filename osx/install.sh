#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"
source $DOTFILES_REPO/script/helpers.bash

curr="$(pwd)"
name="$(basename $(pwd))"

if [[ "$OSTYPE" =~ ^darwinm ]]; then
	info "Installing $name configuration..."
	./osx
	success "$name configuration installed"
fi

exit 0
