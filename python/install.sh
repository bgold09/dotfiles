#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"
source $DOTFILES_REPO/system/helpers.bash

curr="$(pwd)"
name='python'

place_files() {
	ln -f pythonrc.py $HOME/.pythonrc.py
}

e_header "Installing $name configration..."
place_files
e_success "$name confguration installed"
exit 0
