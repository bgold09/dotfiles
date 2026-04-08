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
