winget install Microsoft.PowerShell

pwsh -NoProfile -NoLogo -Command {
    winget install Microsoft.dotnet

    Write-Host "Opening browser; create a GitHub PAT with 'read:packages' scope."
    Start-Process "https://github.com/settings/tokens/new"

    $c = Get-Credential -UserName "bgold09" -Message "Enter GitHub PAT with 'read:packages' scope."
    $nugetSourceName = 'github-bgold09'
    dotnet nuget add source --name $nugetSourceName "https://nuget.pkg.github.com/bgold09/index.json" `
        --username $c.UserName --password $c.GetNetworkCredential().Password

    dotnet tool install --global cnct --source $nugetSourceName

    winget install Git.Git
    git clone --recursive https://github.com/bgold09/dotfiles.git ~\.dotfiles
    Set-Location ~\.dotfiles
    cnct
}
