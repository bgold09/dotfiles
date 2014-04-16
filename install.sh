#!/bin/sh

set -e 

echo 'Cloning and installing dotfiles...'

git clone --recursive https://github.com/bgold09/dotfiles.git
cd dotfiles
sudo bash bootstrap.sh
