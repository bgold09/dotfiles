#!/bin/bash

set -e

name='bash'
declare -a files=('bashrc' 'bash_aliases' 'bash_functions') 

list_files() {
	echo "from $name config:"
	printf -- "  .%s\n" "${files[@]}"
}

place_files() {
	for file in "${files[@]}"; do
		rm -f $HOME/.$file
		ln $file $HOME/.$file
	done
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
