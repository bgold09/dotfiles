force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		# We have color support; assume it's compliant with Ecma-48
		# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
		# a case would tend to support setf rather than setaf.)
		color_prompt=yes
	else
		color_prompt=
	fi
fi

if [ "$color_prompt" = yes ]; then
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]$(last_two_dirs)\[\033[00m\] \$ '
else 
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:$(last_two_dirs) \$ '
fi
unset force_color_prompt color_prompt

if [[ "$(uname -s)" =~ ^CYGWIN.* ]]; then 
	PS1='\[\e]0;\w\a\]\[\e[32m\]\u@\h\[\e[33m\] \W\[\e[0m\] \$ '
fi

export PS1
