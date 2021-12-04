#!/bin/sh

set -e 

# Install PowerShell
sudo apt-get update
sudo apt-get install -y wget apt-transport-https software-properties-common
wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y powershell

# Install cnct
sudo apt-get install -y dotnet-sdk-6.0

read -s -p "Enter GitHub PAT with 'read:packages' scope: " githubPat
dotnet nuget add source --name 'github-bgold09' "https://nuget.pkg.github.com/bgold09/index.json" \
    --username $c.UserName --password $githubPat --store-password-in-clear-text

dotnet tool install --global cnct

echo 'Cloning and installing dotfiles...'

git clone --recursive https://github.com/bgold09/dotfiles.git $HOME/.dotfiles
cd $HOME/.dotfiles

pwsh -NoProfile -NoLogo -Command "& { cnct }"

sudo ./bootstrap.sh
