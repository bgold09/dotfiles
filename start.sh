#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

if [ -z "$DOTFILES_REPO" ]; then
	export DOTFILES_REPO="$(pwd)"
fi
source $DOTFILES_REPO/script/helpers.bash

# Install yarn
echo "Setting up yarn source..."
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

# Install node
echo "Setting up Node.js source..."
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -

echo "Installing Node.js, yarn, and git..."
sudo apt-get update
sudo apt-get install -y nodejs yarn git

echo "Cloning dotfiles repo..."
git clone https://github.com/bgold09/dotfiles $HOME/.dotfiles

# install cnct
echo "Installing cnct..."
mkdir "$HOME/dev"
git clone https://github.com/bgold09/cnct "$HOME/dev/cnct"
cd "$HOME/dev/cnct"
yarn install
npm run compile > /dev/null

cd $HOME/.dotfiles
node $HOME/dev/cnct/dist/src/index.js

exit 0
