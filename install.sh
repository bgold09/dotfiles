#!/bin/sh

set -e 

# Install PowerShell
sudo apt-get update
sudo apt-get install -y wget
source /etc/os-release
wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y powershell

# Install cnct
sudo apt-get install -y dotnet-sdk-8.0

dotnet tool install --global cnct

echo 'Cloning and installing dotfiles...'

git clone --recursive https://bgold09@github.com/bgold09/dotfiles.git $HOME/.dotfiles
cd $HOME/.dotfiles

pwsh -NoProfile -NoLogo -Command "& { cnct }"
