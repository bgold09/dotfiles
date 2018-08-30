$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    Write-Host -ForegroundColor Red "Not running as admin."
    exit 1;
}

$dotfiles="$env:HOME/.dotfiles"

# install scoop
Write-Output "Installing scoop..."
Invoke-Expression (new-object net.webclient).downloadstring('https://get.scoop.sh')
New-Alias -Name scoop -Value "$env:HOME/scoop/apps/scoop/current/bin/scoop.ps1"
# install sudo
scoop install -g sudo

# install choco
Write-Output "Installing chocolatey"
Set-ExecutionPolicy Bypass -Scope Process -Force
# sudo?
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# install yarn
cinst -y git git-credential-manager-for-windows yarn nodejs

# install cnct
mkdir "$env:HOME/dev"
git clone https://github.com/bgold09/cnct "$env:HOME/dev/cnct"
Push-Location "$env:HOME/dev/cnct"
yarn install
npm run compile > $null
Pop-Location

git clone https://github.com/bgold09/dotfiles $env:HOME\.dotfiles

Set-Location $dotfiles
node $env:HOME\dev\cnct\dist\src\index.js