#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

curr="$(pwd)"
name='bash'

place_files() {
	rm -f $HOME/.bash
	ln -s $curr $HOME/.bash
	rm -f $HOME/.bashrc 
	ln bashrc $HOME/.bashrc
}

function e_header() { echo -e "\033[1m$@\033[0m"; }
function e_success() { echo -e " \033[1;32m✔\033[0m $@"; }
function e_error() { echo -e " \033[1;31m✖\033[0m $@"; }
function e_arrow() { echo -e " \033[1;33m➜\033[0m $@"; }

e_header "Installing $name configration..."
place_files
e_success "$name confguration installed"
exit 0
