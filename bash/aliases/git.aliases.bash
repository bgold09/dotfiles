alias g=git
alias gs='git status -sb'
alias gc='git commit -m'
alias ga='git add'
alias gr='cd $(git rev-parse --show-cdup)'

alias git-amend='git commit --amend -C HEAD'
alias git-undo='git reset --soft HEAD^'
