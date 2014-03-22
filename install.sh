#!/bin/bash

set -e

# files to link in home directory
declare -a files=()
backup_dir="$HOME/dotfiles-backup-`date +%s`"
current=`pwd`

function backup_files() {
	mkdir $backup_dir
	for file in "${files[@]}"
	do
		if [ -e $HOME/.$file ]; then
			cp -v $HOME/.$file $backup_dir/$file # > /dev/null 2>&1
		fi
	done
}

function place_files() {
	# for file in "${files[@]}"
	# do
	# 	rm -f $HOME/.$file
	# 	ln $file $HOME/.$file
	# done
	# look for directories of config files
	# each must contain an installation script called `install.sh' and 
	#   have a "-l" option for listing files that will be replaced/linked
	for directory in */ ; do
		cd $current/$directory
		if [ ! -e install.sh ]; then
			echo "WARNING: no \`install.sh\' found for directory $directory"
		else
			./install.sh
		fi
		cd $current
	done
}

function list_files() {
# 	printf -- "  .%s\n" "${files[@]}"
	for directory in */ ; do
		cd $current/$directory 
		if [ -e install.sh ]; then
			./install.sh -l 
		fi
		cd $current
	done
}

echo The following files will be overwritten by this script:
list_files
read -r -p "Would you like to proceed? [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
	place_files
	echo run \`source ~/.bashrc\' to reload your bashrc file
fi

exit 0
