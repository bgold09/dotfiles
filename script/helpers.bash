# Logging
e_header()  { echo -e "\033[1m$@\033[0m"; }
e_success() { echo -e " \033[1;32m✔\033[0m $@"; }
e_error()   { echo -e " \033[1;31m✖\033[0m $@"; }
e_arrow()   { echo -e " \033[1;33m➜\033[0m $@"; }

info()    { printf " [ \033[00;34m..\033[0m ] $1"; }
user()    { printf "\r [ \033[0;33m?\033[0m ] $1 "; }
success() { printf "\r\033[2K [ \033[00;32mOK\033[0m ] $1\n"; }
warn()    { printf "\r\033[2K [\033[0;33mWARN\033[0m] $1\n"; }
fail()    { printf "\r\033[2K [\033[0;31mFAIL\033[0m] $1\n"; }
