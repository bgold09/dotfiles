# search
alias grep='grep --color'                     # show differences in colour
alias egrep='egrep --color=auto'              # show differences in colour
alias fgrep='fgrep --color=auto'              # show differences in colour

# enable color support of ls and add aliases
eval "`dircolors -b`"
alias ls='ls --color=auto -hBG'
# alias ls='ls -hF --color=tty'                 # classify files in colour
alias ll='ls -l'                                # long list
alias la='ls -A'                                # all but . and ..
alias l='ls -CF'
alias lla='ls -la'
alias ld='ls -l --color | less'
alias lda='ls -la --color | less'

# navigation, directories
# Tree
if [ ! -x "$(which tree 2>/dev/null)" ]; then
	alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
fi

alias mkdir='mkdir -pv'                         # make parent dirs, verbose

# files
# don't delete / or prompt if deleting >= 3 files
alias rm='rm -I --preserve-root'
alias wget='wget -c'

# Default to human readable figures
alias df='df -h'
alias du='du -h'

# less pager
alias less='less -R'

# misc
alias whence='type -a'             # where, of a sort
alias mount='mount | column -t'
alias h='history'
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'
