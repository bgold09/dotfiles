#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"
source $DOTFILES_REPO/script/helpers.bash

curr="$(pwd)"
name="$(basename $(pwd))"

place_files() {
	if [ -n "$1" ]; then
		backup_dir="$1/$name"
		mkdir $backup_dir
		# Copy any files that will be overwritten i
		# to the backup directory
	fi
	
	# Choose the best method to link files and directories
	# (e.g. loop through, file-by-file, etc.)
}

info "Installing $name configuration..."
place_files $1
success "$name configuration installed"
exit 0
