#!/bin/bash

set -e

name='bash'
declare -a files=('aliases' 'functions' 'prompt') 

list_files() {
	echo "from $name config:"
	printf -- "  .%s\n" "${files[@]}"
}

place_files() {
	rm -f $HOME/.bash
	ln -s `pwd` $HOME/.bash
}

if [[ ! -z $1 ]]; then
	if [ $1 == "-l" ]; then
		list_files 
		exit 0
	fi
fi

echo installing $name configration...
place_files
echo $name confguration installed
