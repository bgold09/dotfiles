#!/bin/bash

set -e

# files to link in home directory
declare -a files=('bashrc' 'gitconfig' 'pythonrc.py' 'bash_aliases')
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
	for file in "${files[@]}"
	do
		rm -f $HOME/.$file
		ln $file $HOME/.$file
	done
	# look for directories of config files
	# each must contain an installation script called `install.sh' and 
	#   have a "-l" option for listing files that will be replaced/linked
	for directory in "`ls -d */`"
	do
		cd $current/$directory
		if [ ! -e install.sh ]; then
			echo "WARNING: no \`install.sh\' found for directory $directory"
		else
			./install.sh
		fi
	done
	cd $current
}

function list_files() {
	printf -- "  .%s\n" "${files[@]}"
	for directory in "`ls -d */`"
	do
		if [ -e install.sh ]; then
			$directory./install.sh -l 
		fi
	done
}

echo The following files will be overwritten by this script:
list_files
read -p "Would you like to proceed? (y/n) " -n 1
echo 
if [[ $REPLY =~ ^[Yy]$ ]]; then
	place_files
	echo run \`source ~/.bashrc\' to reload your bashrc file
fi

unset place_files
unset backup_files
