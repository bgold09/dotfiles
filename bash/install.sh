#!/bin/bash

set -e

curr="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
name='bash'
declare -a files=('aliases' 'functions' 'prompt') 

place_files() {
	rm -f $HOME/.bash
	ln -s $curr $HOME/.bash
	rm -f $HOME/.bashrc 
	ln $curr/bashrc $HOME/.bashrc
}

echo installing $name configration...
place_files
echo $name confguration installed
exit 0
