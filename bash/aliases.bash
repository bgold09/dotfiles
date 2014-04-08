# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.

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

# vim 
alias vi=vim
alias svi='sudo vi'
alias edit='vim'

# git 
alias g=git
alias gs='git status'
alias gc='git commit -m'
alias ga='git add'

# misc
alias whence='type -a'             # where, of a sort
alias mount='mount | column -t'
alias h='history'
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'

# Debian things
alias apt-get='sudo apt-get'
alias install='sudo apt-get install'
alias update='sudo apt-get update && sudo apt-get update'
