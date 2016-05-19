#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

if [ -z "$DOTFILES_REPO" ]; then
	export DOTFILES_REPO="$(pwd)"
fi
source $DOTFILES_REPO/script/helpers.bash

run_install() {
	local backup_dir
	if [ -n "$BACKUP" ]; then
		backup_dir="$HOME/dotfiles-backup-$(date +%s)"
		mkdir $backup_dir
	fi

	local exclude=0
	if [ -e "$HOME/.bootstrap.exclusions" ]; then
		declare -a exclusions
		readarray -t exclusions < "$HOME/.bootstrap.exclusions"
		exclude=1
	fi

	# Find the installers and run them
	find . -mindepth 2 -name install.sh | sort | while read installer; do 
		if [ $exclude -eq 0 ]; then
			sh -c "${installer} $backup_dir"
		else 
			local name="$(echo "$installer" | cut -d'/' -f 2)"
			if [ ! "$(array_contains "$name" "$(declare -p exclusions)")" ]; then
				sh -c "${installer} $backup_dir"
			else
				warn "Skipping $name installation"
			fi
		fi
	done
	unset exclusions

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

array_contains() {
	local search="$1"
	eval "declare -a array="${2#*=}
	local found=
	for name in "${array[@]}"; do 
		if [[ $name == $search ]]; then
			echo 1
			found=1
			return
		fi
	done
}

check_installed() {
	if [ -z "$(type -P $1)" ]; then
		echo 0
	else
		echo 1
	fi
}

install_dependencies() {
	e_header "Installing/upgrading dependencies..."
	if [[ "$OSTYPE" =~ ^linux-gnu ]]; then
		install_dependencies_debian
	elif [[ "$OSTYPE" =~ ^darwin ]]; then
		install_dependencies_osx
	elif [[ "$OSTYPE" =~ ^cygwin ]]; then 
		install_dependencies_cygwin
	else
		fail "Current platform is not supported for installing dependencies."
	fi
	e_success "Dependencies installed/upgraded"
}

install_dependencies_debian() {
	e_arrow "Updating package index files from their sources..."
	sudo apt-get update &> /dev/null
	e_success "Package index files updated"

	if [ -z "$UPGRADE" ]; then
		local install_cmd="sudo apt-get -y -q install"
	else
		local install_cmd="sudo apt-get -y -q upgrade"
	fi

	install_dependencies_list "$install_cmd" "check_installed_debian" "packages-debian"
}

install_dependencies_osx() {
	if [ ! "$(check_installed gcc)" ]; then
		e_error "XCode or the Command Line Tools for XCode must be installed first"
		exit 1
	fi
	
	if [ ! "$(check_installed brew)" ]; then
		e_arrow "Installing Homebrew (OSX package manager)"
		ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
		e_success "Homebrew installed"
	fi

	e_arrow "Updating homebrew and homebrew formulae..."
	brew update &> /dev/null
	e_success "Homebrew and formulae updated"

	if [ -z "$UPGRADE" ]; then
		local install_cmd="brew install"
	else
		local install_cmd="brew upgrade"
	fi

	install_dependencies_list "$install_cmd" "check_installed_osx" packages-osx
}

check_installed_debian() {
	dpkg-query -l $1 &> /dev/null && echo 0 || echo 1
}

check_installed_osx() {
	if [ "$(brew ls --versions $1)" ]; then
		echo 0
	else
		echo 1
	fi
}

check_installed_cygwin() {
	if [ "$(cygcheck -dc $pkg | sed '3q;d')" ]; then
		echo 0
	else
		echo 1
	fi
}

# Argument 3 must be the name of a function that takes the name 
# of a package and returns 0 if it is installed and 1 otherwise
install_dependencies_list() {
	local install_cmd="$1"
	local check="$2"
	local packages_file="$3"

	if [ -z "$UPGRADE" ]; then
		local verb1="Installing"
		local verb2="installed"
	else
		local verb1="Upgrading"
		local verb2="upgraded"
	fi

	while IFS= read -r pkgname; do
		if [ -n "$UPGRADE" ] || [ ! "$($check $pkgname)" ]; then
			e_arrow "$verb1 $pkgname..."
			$install_cmd $pkgname &> /dev/null
			e_success "$pkgname $verb2"
		fi
	done < "$packages_file"
}

install_dependencies_cygwin() {
	if [ ! "$(cygcheck -dc curl | sed '3q;d')" ]; then
		e_error "Please install 'curl' and rerun this script."
		exit 1
	fi

	if [ -n $UPGRADE ] || [ ! "$(type -P sage)" ]; then
		e_arrow "Installing the latest version of sage..."
		curl -fL -o /tmp/sage \
			http://rawgit.com/svnpenn/sage/master/sage
		install /tmp/sage /bin
		e_success "sage installed"
	fi

	e_arrow "Updating Cygwin master package list..."
	sage update &> /dev/null 
	e_success "Cygwin package master package list updated"

	if [ -z "$UPGRADE" ]; then
		local install_cmd="sage install"
	else
		local install_cmd="sage upgrade"
	fi

	install_dependencies_list "$install_cmd" "check_installed_cygwin" "packages-cygwin"
}

bootstrap() {
	[ -z "$DEP" ] && install_dependencies
	run_install

	if [ -n "$BACKUP" ]; then
		echo "A backup of your previous config files has been made in $backup_dir"
	fi

	echo "Run \`source ~/.bashrc' to reload your bashrc file."
	echo "Run \`vim +PlugInstall +qall' to install vim plugins."
	echo Some changes may require a terminal restart to take effect.
}

usage() {
	cat << EOF
Usage: $0 [OPTION]...
Install configurations for bash, git, vim and python.

-b    create a backup of current config files in home directory
-d    install without checking dependencies
-f    run install without prompting
-h    display this help and exit
-u    upgrade package manager and packages (ignored if '-d' is used)
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
			UPGRADE=1
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
