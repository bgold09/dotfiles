if (-not ([Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544')) {
    Write-Host "Not running as an administrator; this script should be run in an admin session to avoid excessive UAC prompts."
    $answer = Read-Host -Prompt "Run anyway? (Y/n)"
    if ($answer -eq "n") {
        exit
    } elseif ($answer -ne "y") {
        throw "Unrecognized input '$answer'"
    }
}

winget install --source winget --id Microsoft.PowerShell
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") `
    + ";" `
    + [System.Environment]::GetEnvironmentVariable("Path", "User")

pwsh -NoProfile -NoLogo -Command {
    winget install --source winget --id "Microsoft.DotNet.SDK.6"
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") `
        + ";" `
        + [System.Environment]::GetEnvironmentVariable("Path", "User")

    Write-Host "Opening browser; create a GitHub PAT with 'read:packages' scope."
    Start-Process "https://github.com/settings/tokens/new"

    $c = Get-Credential -UserName "bgold09" -Message "Enter GitHub PAT with 'read:packages' scope."
    dotnet nuget add source --name 'github-bgold09' "https://nuget.pkg.github.com/bgold09/index.json" `
        --username $c.UserName --password $c.GetNetworkCredential().Password

    dotnet tool install --global cnct
    dotnet tool install --global dotnet-suggest --version '1.1.327201'

    winget install --source winget --id Git.Git
    git clone --recursive https://github.com/bgold09/dotfiles.git $HOME\.dotfiles
    Set-Location $HOME\.dotfiles
    cnct
}
