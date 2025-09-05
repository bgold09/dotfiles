function setRegistryDword {
    param([string]$path, [string]$name, $value)

    if (-not (Test-Path -Path $path)) {
        New-Item -Path (Split-Path -Path $path -Parent) `
            -Name (Split-Path -Path $path -Leaf)
    }

    New-ItemProperty -Force -PropertyType DWord `
        -Path $path -Name $name -Value $value 
}

function createRegKeyInfo {
    param([string]$path, [string]$name, [int]$value)

    return [PSCustomObject]@{
        Path = $path
        Name = $name
        Value = $value
    }
}

$dotPath = "$HOME/.dotfiles"

## Trust the PowerShell Gallery repository
$psGalleryName = "PSGallery"
$psGallery = Get-PSRepository -Name $psGalleryName
if (!$psGallery.Trusted) {
    Set-PSRepository -Name $psGalleryName -InstallationPolicy Trusted
}

## Install PowerShell modules
$psModules = @(
   "posh-git" 
   "Terminal-Icons"
)

Write-Host "Installing PowerShell modules"
foreach ($psModuleName in $psModules) {
    $module = Get-Module -ListAvailable -Name $psModuleName
    if ($null -eq $module) {
        Install-Module -Name $psModuleName
    }
}

if ($IsWindows) {
    Write-Host "Installing packages with winget..."
    winget import $dotPath\windows\winget-packages.json --accept-package-agreements


    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") `
        + ";" `
        + [System.Environment]::GetEnvironmentVariable("Path", "User")


    # Set up aliases if we ever need a cmd prompt
    New-ItemProperty -Force -PropertyType String -Path "HKCU:\Software\Microsoft\Command Processor" `
        -Name AutoRun -Value "$dotPath\windows\win32-rc.cmd" `
        -ErrorAction Ignore

    # see http://www.experts-exchange.com/OS/Microsoft_Operating_Systems/Windows/A_2155-Keyboard-Remapping-CAPSLOCK-to-Ctrl-and-Beyond.html
    # http://msdn.microsoft.com/en-us/windows/hardware/gg463447.aspx
    $scancodeMapHex = "00,00,00,00,00,00,00,00,02,00,00,00,1d,00,3a,00,00,00,00,00".Split(',') | ForEach-Object { "0x$_" }
    New-ItemProperty -Force -PropertyType Binary -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout" `
        -Name "Scancode Map" -Value ([byte[]]$scancodeMapHex)

    $explorerRegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    $virtualDesktopPinnedAppsRegPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops\PinnedApps"
    $themesRegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    $regKeys = @(
        # Taskbar alignment
        createRegKeyInfo $explorerRegPath "TaskbarAl" 0

        # Taskbar chat
        createRegKeyInfo $explorerRegPath "TaskbarMn" 0
        
        createRegKeyInfo $explorerRegPath "ShowCortanaButton" 0
        createRegKeyInfo $explorerRegPath "HideFileExt" 0
        createRegKeyInfo $explorerRegPath "ShowTaskViewButton" 0
        createRegKeyInfo $explorerRegPath "MultiTaskingAltTabFilter" 3
        createRegKeyInfo "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" "SearchboxTaskbarMode" 0
        createRegKeyInfo "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PenWorkspace" "PenWorkspaceButtonDesiredVisibility " 0
        createRegKeyInfo "HKCU:\Control Panel\Desktop" "CaretWidth" 2
        createRegKeyInfo $virtualDesktopPinnedAppsRegPath "{6D809377-6AF0-444B-8957-A3773F02200E}\ConEmu\ConEmu64.exe" 0
        createRegKeyInfo $virtualDesktopPinnedAppsRegPath "com.squirrel.Teams.Teams" 0
        createRegKeyInfo $virtualDesktopPinnedAppsRegPath "Microsoft.WindowsTerminal_8wekyb3d8bbwe!App" 0
        createRegKeyInfo $themesRegPath AppsUseLightTheme 0
        createRegKeyInfo $themesRegPath SystemUsesLightTheme 0
    )

    foreach ($item in $regKeys) {
        setRegistryDword $item.Path $item.Name $item.Value
    }
}

# install VS Code extensions 
$vscodeExtensions = @(
    'asvetliakov.vscode-neovim'
    'DavidAnson.vscode-markdownlint'
    'donjayamanne.githistory'
    'eamodio.gitlens'
    'James-Yu.latex-workshop'
    'ms-dotnettools.csharp'
    'ms-vscode.powershell'
    'streetsidesoftware.code-spell-checker'
    'vscodevim.vim'
)

if (-not $IsLinux -or ($null -eq $env:WSL_DISTRO_NAME)) {
    $vscodeInstalledExtensions = code --list-extensions
    foreach ($extensionName in $vscodeExtensions) {
        if ($vscodeInstalledExtensions -notcontains $extensionName) {
            code --install-extension $extensionName
        }
    }
}
