#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"
source $DOTFILES_REPO/script/helpers.bash

curr="$(pwd)"
name="$(basename $(pwd))"

info "Installing $name configuration..."
if [[ "$OSTYPE" =~ ^darwinm ]]; then
	./osx
	success "$name configuration installed"
else
	warn "not on an OS X system"
fi

exit 0
