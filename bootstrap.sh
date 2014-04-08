#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

current="$(pwd)"

# files to link in home directory
backup_dir="$HOME/dotfiles-backup-`date +%s`"
declare -a DIRS=()
declare -a DIRSINSTALL=('bash' 'dotvim' 'git' 'python')

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

# Logging
function e_header() { echo -e "\033[1m$@\033[0m"; }
function e_success() { echo -e " \033[1;32m✔\033[0m $@"; }
function e_error() { echo -e " \033[1;31m✖\033[0m $@"; }
function e_arrow() { echo -e " \033[1;33m➜\033[0m $@"; }

install_dependencies() {
	e_header "Installing dependencies..."
	if [[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]]; then
		install_dependencies_ubuntu
	elif [[ "$OSTYPE" =~ ^darwin ]]; then
		install_dependencies_osx
	else 
		dependencies_needed
		exit 1
	fi
}

install_dependencies_ubuntu() {
	install_cmd="sudo apt-get -y install"
	version="$(lsb_release -r | cut -f2)"

	if [ ! "$(type -P git)" ]; then
		e_arrow "Installing git..."
		$install_cmd git-core
		e_success "git installed"
	fi

	if [ ! "$(type -P ctags-exuberant)" ]; then
		e_arrow "Installing ctags-exuberant..."
		$install_cmd ctags-exuberant
		e_success "ctags-exuberant installed"
	fi

	if [ ! "$(type -P ag)" ]; then
		e_arrow "Installing ag (the_silver_searcher)..."
		if [ $(echo "$version >= 13.10" | bc) -ne 0 ]; then
			$install_cmd silversearcher-ag
		else
			for pkg in "automake" "pkg-config" "libpcre3-dev" "zlib1g-dev" "liblzma-dev"; do 
				e_arrow "Installing $pkg..."
				$install_cmd $pkg
				e_success "$pkg installed"
			done

			git clone https://github.com/ggreer/the_silver_searcher /tmp/silver
			pushd /tmp/silver
			./build.sh
			sudo make install
			popd
		fi
		e_success "ag (the_silver_searcher) installed"
	fi
}

install_dependencies_osx() {
	install_cmd="brew install"

	if [ ! "$(type -P gcc)" ]; then
		e_error "XCode or the Command Line Tools for XCode must be installed first"
		exit 1
	fi

	if [ ! "$(type -P ctags-exuberant)" ]; then
		e_arrow "Installing ctags-exuberant..."
		$install_cmd ctags-exuberant
		e_success "ctags-exuberant installed"
	fi

	if [ ! "$(type -P ag)" ]; then
		e_arrow "Installing ag (the_silver_searcher)..."
		$install_cmd the_silver_searcher
		e_success "ag (the_silver_searcher) installed"
	fi
}

dependencies_needed() {
	fail=
	pkgs=
	for pkg in "git" "ctags-exuberant"; do
		if [ ! "$(type -P $pkg)" ]; then
			fail=1
			pkgs="$pkgs $pkg"
		fi
	done

	if [ $fail -eq 1 ]; then
		e_error "You must install the following dependencies:"
		echo $pkgs
		echo "Install these, then run this script again."
		exit 1
	fi

}

bootstrap() {
	install_dependencies
	place_files
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	bootstrap
else 
	echo This script may overwrite files in your home directory.
	read -r -p "Would you like to proceed? [y/N] " response
	if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
		bootstrap
		echo run \`source ~/.bashrc\' to reload your bashrc file
	fi
fi

exit 0
