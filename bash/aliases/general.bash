## Search
alias grep='grep --color'                     # show differences in color
alias egrep='egrep --color=auto'              # show differences in color
alias fgrep='fgrep --color=auto'              # show differences in color

## Listing files with `ls`
if [[ ! "$OSTYPE" =~ ^darwin ]]; then eval "`dircolors -b`"; fi

# detect which `ls` flavor to use
if ls --color > /dev/null 2>&1; then  # GNU `ls`
	colorflag="--color"
else                                  # OS X `ls`
	colorflag="-G"
fi

# enable color support of `ls` and add aliases
alias ls="ls ${colorflag} -hBG"
alias ll='ls -l'                                # long list
alias la='ls -A'                                # all but . and ..
alias l='ls -CF'
alias lla='ls -la'
alias ld="ls -l ${colorflag} | less"
alias lda="ls -la ${colorflag} | less"

## Navigation, directories
# Tree
if [ ! -x "$(which tree 2>/dev/null)" ]; then
	alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
fi

alias mkdir='mkdir -pv'                         # make parent dirs, verbose

## Files
if [[ "$OSTYPE" =~ ^darwin ]]; then
	promptflag=
else
	promptflag="-I"
fi

# don't delete / or prompt if deleting >= 3 files
alias rm="rm ${promptflag} --preserve-root"
alias wget='wget -c'

## Default to human readable figures
alias df='df -h'
alias du='du -h'

## Less
alias less='less -R'

## Misc
alias whence='type -a'             # where, of a sort
alias mount='mount | column -t'
alias h='history'
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'
