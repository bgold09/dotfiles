#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

if [ -z "$DOTFILES_REPO" ]; then
	export DOTFILES_REPO="$(pwd)"
fi
source $DOTFILES_REPO/script/helpers.bash

run_install() {
	if [ -n "$BACKUP" ]; then
		backup_dir="$HOME/dotfiles-backup-$(date +%s)"
		mkdir $backup_dir
	fi

	# Find the installers and run them
	find . -mindepth 2 -name install.sh | sort | while read installer; do 
		sh -c "${installer} $backup_dir"
	done

	if [ -r $HOME/bin ]; then
		if [ -n "$BACKUP" ]; then
			mkdir $backup_dir/bin
			cp -r $HOME/bin/* $backup_dir/bin/
		fi
		
		if [ -h "$HOME/bin" ]; then
			unlink $HOME/bin
		elif [ -d "$HOME/bin" ]; then
			rm -rf $HOME/bin
		fi
	fi

	ln -s $DOTFILES_REPO/bin $HOME/bin
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
	install_cmd="sudo apt-get -y -q install"

	declare -A deps
	deps[git]=git-core
	deps[ctags-exuberant]=ctags-exuberant
	deps[tmux]=tmux
	deps[pip]=python-pip

	install_dependencies_list "$install_cmd" "$(declare -p deps)"
	install_python_packages

	# install the_silver_searcher if on a Ubuntu system
	if [[ ! "$(type -P ag)" && "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]]; then
		version="$(lsb_release -r | cut -f2)"
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
}

install_python_packages() {
	declare -a pkgs=('git-up')
	for pkg in "${pkgs[@]}"; do 
		if [ -z "$(pip show $pkg)" ]; then
			e_arrow "Installing python package $pkg..."
			sudo pip install --quiet $pkg
			e_success "Python package $pkg installed"
		fi
	done
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

update_repo() {
	info "Updating the repository..."
        
	git pull origin master > /dev/null 2>&1
	if [ ! $? -eq 0 ]; then
	 	fail "Something went wrong updating the repository"
	 	exit 1
	fi
	
	cd "$DOTFILES_REPO/vim/bundle/vundle" && git pull origin master > /dev/null 2>&1
	if [ ! $? -eq 0 ]; then
		fail "Something went wrong updating the repo (update vundle)"
	 	exit 1
	fi
	cd $DOTFILES_REPO
        
	success "Repository updated to latest version"
}

bootstrap() {
	[ -n "$UPDATE" ] && update_repo
	[ -z "$DEP" ] && install_dependencies
	run_install

	if [ -n "$BACKUP" ]; then
		echo "A backup of your previous config files has been made in $backup_dir"
	fi

	echo "Run \`source ~/.bashrc' to reload your bashrc file."
	echo "Run \`vim +PluginInstall +qall' to install vim plugins."
	echo Some changes may require a restart to take effect.
}

usage() {
	cat << EOF
Usage: $0 [OPTION]...
Install configurations for bash, git, python and git.

-b    create a backup of current config files in home directory
-d    install without checking dependencies
-f    run install without prompting
-h    display this help and exit
-u    update the repository before installing
EOF

	exit 0
}

# Parse command line arguments
while getopts "bdfhu" o; do
	case "${o}" in 
		b)
			BACKUP=1
			;;
		d)
			DEP=1
			;;
		f)
			FORCE=1
			;;
		h)
			usage
			;;
		u)
			UPDATE=1
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
