#!/bin/bash

set -e

# files to link in home directory
declare -a files=('bashrc' 'gitconfig' 'pythonrc.py')
backup_dir="$HOME/dotfiles-backup-`date +%s`"

mkdir $backup_dir
for file in "${files[@]}"
do
	if [ -e $HOME/.$file ]; then
		cp -v $HOME/.$file $backup_dir/$file # > /dev/null 2>&1
		rm -f $HOME/.$file
	fi
	ln $file $HOME/.$file
done

# look for directories of config files
# each must contain an installation script called `install.sh'
for directory in "`ls -d */`"
do
	cd $directory
	if [ ! -e install.sh ]; then
		echo WARNING: no \`install.sh\' found for directory $directory
	else
		./install.sh
	fi
done

echo backups of your dotfiles have been copied to $backup_dir
echo run \`source ~/.bashrc\' to reload your bashrc file
