param(
    [switch]$Personal
)

if (-not ([Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544')) {
    Write-Host "Not running as an administrator; this script should be run in an admin session to avoid excessive UAC prompts."
    $answer = Read-Host -Prompt "Run anyway? (Y/n)"
    if ($answer -eq "n") {
        return
    } elseif ($answer -ne "y") {
        throw "Unrecognized input '$answer'"
    }
}

winget install --source winget --id Microsoft.PowerShell
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") `
    + ";" `
    + [System.Environment]::GetEnvironmentVariable("Path", "User")

pwsh -NoProfile -NoLogo -Command {
    param([bool]$Personal)

    winget install --source winget --id "Microsoft.DotNet.SDK.8"
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") `
        + ";" `
        + [System.Environment]::GetEnvironmentVariable("Path", "User")

    dotnet tool install --global cnct
    dotnet tool install --global dotnet-suggest --allow-roll-forward

    if ($Personal) {
        $cnctConfigDir = "$env:LOCALAPPDATA\cnct"
        New-Item -ItemType Directory -Path $cnctConfigDir -Force | Out-Null
        '{ "tags": ["personal"] }' | Set-Content -Path "$cnctConfigDir\settings.json" -Encoding UTF8
        Write-Host "Created personal machine settings: $cnctConfigDir\settings.json"
    }

    winget install --source winget --id Git.Git
    git clone --recursive https://github.com/bgold09/dotfiles.git $HOME\.dotfiles
    Set-Location $HOME\.dotfiles
    cnct
} -args $Personal.IsPresent
