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
