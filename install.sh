#!/bin/bash

set -e

# files to link in home directory
declare -a files=()
backup_dir="$HOME/dotfiles-backup-`date +%s`"
current="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
declare -a DIRS=('git' 'python')
declare -a DIRSINSTALL=('bash' 'dotvim')

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
	# directories with installation scripts
	for directory in "${DIRSINSTALL[@]}" ; do
		if [ ! -e $current/$directory/install.sh ]; then
			echo "WARNING: no \`install.sh\' found for directory $current/$directory"
		else
			$current/$directory/install.sh
		fi
	done

	# directories without installation scripts, files/directories only
	# no special installation behavior needed
	for directory in "${DIRS[@]}" ; do
		for file in $current/$directory ; do
			if [ -f $file ] && [ -r $file ]; then
				rm -f $HOME/.$(basename $file)
				ln $file $HOME/.$(basename $file)
			elif [ -d $file ]; then
				for f in $file/* ; do
					rm -f $HOME/.$(basename $f)
					ln -s $f $HOME/.$(basename $f)
				done
			fi
		done
	done
}

echo The following configurations will be overwritten by this script:
echo "  bash, git, python, vim"
read -r -p "Would you like to proceed? [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
	place_files
	echo run \`source ~/.bashrc\' to reload your bashrc file
fi

exit 0
