#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

backup_dir="$HOME/dotfiles-backup-`date +%s`"

export DOTFILES_REPO="$(pwd)"
source $DOTFILES_REPO/script/helpers.bash

backup_files() {
	mkdir $backup_dir
	for file in "${files[@]}"
	do
		if [ -e $HOME/.$file ]; then
			cp -v $HOME/.$file $backup_dir/$file # > /dev/null 2>&1
		fi
	done
}

run_install() {
	# Find the installers and run them
	find . -mindepth 2 -name install.sh | sort | while read installer; do 
		sh -c "${installer}"
	done
}

install_dependencies() {
	e_header "Installing dependencies..."
	if [ "$(type -P apt-get)" ]; then
		install_dependencies_debian
	elif [[ "$OSTYPE" =~ ^darwin ]]; then
		install_dependencies_osx
	else 
		dependencies_needed
		exit 1
	fi
}

install_dependencies_debian() {
	install_cmd="sudo apt-get -y install"
	version="$(lsb_release -r | cut -f2)"

	declare -A deps
	deps[git]=git-core
	deps[ctags-exuberant]=ctags-exuberant
	deps[tmux]=tmux

	install_dependencies_list "$install_cmd" "$(declare -p deps)"

	# install the_silver_searcher if on a Ubuntu system
	if [[ ! "$(type -P ag)" && "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]]; then
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

	install_pip
}

install_dependencies_osx() {
	install_cmd="brew install"

	if [ ! "$(type -P gcc)" ]; then
		e_error "XCode or the Command Line Tools for XCode must be installed first"
		exit 1
	fi
	
	if [ ! "$(type -P brew)" ]; then
		e_arrow "Installing Homebrew (OSX package manager)"
		ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
		e_success "Homebrew installed"
	fi

	declare -A deps
	deps[ctags-exuberant]=ctags-exuberant
	deps[ag]=the_silver_searcher
	deps[tmux]=tmux
	
	install_dependencies_list "$install_cmd" "$(declare -p deps)"

	install_pip
}

install_pip() {
	if [ ! "$(type -P pip)" ]; then
		e_arrow "Installing pip (Python package manager)..."
		wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py
		mv get-pip.py /tmp
		sudo python /tmp/get-pip.py
	fi
}

install_dependencies_list() {
	install_cmd="$1"
	eval "declare -A deps="${2#*=}
	for key in "${!deps[@]}"; do 
		if [ ! "$(type -P $key)" ]; then
			e_arrow "Installing $key..."
			$install_cmd ${deps[$key]}
			e_success "$key installed"
		fi
	done
	
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
	[ -z "$DEP" ] && install_dependencies
	run_install
	echo "Run \`source ~/.bashrc' to reload your bashrc file"
	echo Some changes may require a restart to take effect
}

usage() {
	cat << EOF
Usage: $0 [OPTION]...
Install configurations for bash, git, python and git.

-d    install without checking dependencies
-f    run install without prompting
-h    display this help and exit
EOF

	exit 0
}

# Parse command line arguments
while getopts "dfh" o; do
	case "${o}" in 
		d)
			DEP=1
			;;
		f)
			FORCE=1
			;;
		h)
			usage
			;;
		*)
			usage
			;;
	esac
done
shift $((OPTIND-1))

if [ -n "$FORCE" ]; then
	bootstrap
else 
	echo This script may overwrite files in your home directory.
	read -r -p "Would you like to proceed? [y/N] " response
	if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
		bootstrap
	fi
fi

exit 0
