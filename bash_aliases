#
# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.
#
# Interactive operation...
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'
#
# Default to human readable figures
#alias df='df -h'
#alias du='du -h'
#
# Misc :)
# alias less='less -r'                          # raw control characters
# alias whence='type -a'                        # where, of a sort
alias grep='grep --color'                       # show differences in colour
# alias egrep='egrep --color=auto'              # show differences in colour
# alias fgrep='fgrep --color=auto'              # show differences in colour
#

# enable color support of ls and add aliases
if [ "$TERM" != "dumb" ]; then
	eval "`dircolors -b`"
	alias ls='ls --color=auto'
	alias dir='ls --color=auto --format=vertical'
	alias vdir='ls --color=auto --format=long'
fi

# Some shortcuts for different directory listings
# alias ls='ls -hF --color=tty'                 # classify files in colour
alias ll='ls -l'                                # long list
alias la='ls -A'                                # all but . and ..
alias l='ls -CF'                                #

# navigation, directories
alias ..='cd ..'
alias mkdir='mkdir -pv'                         # make parent dirs, verbose

# files
# don't delete / or prompt if deleting >= 3 files
alias rm='rm -I --preserve-root'
alias wget='wget -c'

# vim 
alias vi=vim
alias svi='sudo vi'
alias edit='vim'

# ssh connections
alias gd='ssh -t goodermuth@ssh.goodermuth.com -p 11992 "cd dev/websites/himalaya ; bash"'
alias pi='ssh -t brian@brianjgolden.com "bash"'
alias ladon='ssh -t bwg5079@ladon.cse.psu.edu "csh"'

# misc
alias mount='mount | column -t'
alias h='history'
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'

# Debian things
alias apt-get="sudo apt-get"
alias update='sudo apt-get update && sudo apt-get update'
