#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"
source $DOTFILES_REPO/system/helpers.bash

curr="$(pwd)"
name="$(basename $(pwd))"

if [[ "$OSTYPE" =~ ^darwinm ]]; then
	info "Installing $name configration..."
	./osx
	success "$name confguration installed"
fi

exit 0
