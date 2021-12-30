function reloadPath() {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") `
        + ";" `
        + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

winget install --source winget --id Microsoft.PowerShell
reloadPath

pwsh -NoProfile -NoLogo -Command {
    winget install --source winget --id Microsoft.dotnet
    reloadPath

    Write-Host "Opening browser; create a GitHub PAT with 'read:packages' scope."
    Start-Process "https://github.com/settings/tokens/new"

    $c = Get-Credential -UserName "bgold09" -Message "Enter GitHub PAT with 'read:packages' scope."
    dotnet nuget add source --name 'github-bgold09' "https://nuget.pkg.github.com/bgold09/index.json" `
        --username $c.UserName --password $c.GetNetworkCredential().Password

    dotnet tool install --global cnct
    dotnet tool install --global dotnet-suggest

    winget install --source winget --id Git.Git
    git clone --recursive https://github.com/bgold09/dotfiles.git $HOME\.dotfiles
    Set-Location $HOME\.dotfiles
    cnct
}
