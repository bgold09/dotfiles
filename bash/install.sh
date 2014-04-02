#!/bin/bash

set -e

name='bash'
declare -a files=('aliases' 'functions' 'prompt') 

list_files() {
	echo "from $name config:"
	printf -- "  .%s\n" "${files[@]}"
}

place_files() {
	mkdir -p $HOME/.bash
	for file in "${files[@]}"; do
		rm -f $HOME/.bash/$file
		ln $file $HOME/.bash/$file
	done

	rm -f $HOME/.bashrc
	ln bashrc $HOME/.bashrc
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
