# bash functions

# Move up directories a given number of times
updir() {
	if [ -z $1 ]; then
		cd ..
	else
		dir=''
		for i in `seq 1 $1`; do
			dir=../$dir
		done
		cd $dir
	fi
}
alias ..=updir

# This function defines a 'cd' replacement function capable of keeping, 
# displaying and accessing history of visited directories, up to 10 entries.
# acd_func 1.0.5, 10-nov-2004
# Petar Marinov, http:/geocities.com/h2428, this is public domain
cd_func()
{
	local x2 the_new_dir adir index
	local -i cnt

	if [[ $1 ==  "--" ]]; then
		dirs -v
		return 0
	fi

	the_new_dir=$1
	[[ -z $1 ]] && the_new_dir=$HOME

	if [[ ${the_new_dir:0:1} == '-' ]]; then
		# Extract dir N from dirs
		index=${the_new_dir:1}
		[[ -z $index ]] && index=1
		adir=$(dirs +$index)
		[[ -z $adir ]] && return 1
		the_new_dir=$adir
	fi

	# '~' has to be substituted by ${HOME}
	[[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"

	# Now change to the new dir and add to the top of the stack
	pushd "${the_new_dir}" > /dev/null
	[[ $? -ne 0 ]] && return 1
	the_new_dir=$(pwd)

	# Trim down everything beyond 11th entry
	popd -n +11 2>/dev/null 1>/dev/null

	# Remove any other occurence of this dir, skipping the top of the stack
	for ((cnt=1; cnt <= 10; cnt++)); do
		x2=$(dirs +${cnt} 2>/dev/null)
		[[ $? -ne 0 ]] && return 0
		[[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
		if [[ "${x2}" == "${the_new_dir}" ]]; then
			popd -n +$cnt 2>/dev/null 1>/dev/null
			cnt=cnt-1
		fi
	done

	return 0
}
alias cd=cd_func

# finds the last two directories in the current working 
# directory (expands $HOME to '~')
last_two_dirs() {
	if [ "$(pwd)" == $HOME ]; then
		echo "~"
	else
		t="$(pwd | sed -e "s|$HOME|~|g")"
		p1="$(echo "$t" | awk -F\/ '{print $(NF-1)}')"
		p2="$(echo "$t" | awk -F\/ '{print $(NF)}')"
		echo "$p1/$p2"
	fi
}

# Open Notepad++ on a windows machine
npp() {
	/cygdrive/c/Program\ Files\ \(x86\)/Notepad++/notepad++.exe $(cygpath -w -- "$@")
}
if [ $(uname -o) != "Cygwin" ]; then unset -f npp; fi
