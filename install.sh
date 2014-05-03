#!/bin/sh

set -e 

echo 'Cloning and installing dotfiles...'

git clone --recursive https://github.com/bgold09/dotfiles.git $HOME/.dotfiles
cd $HOME/.dotfiles
sudo ./bootstrap.sh
