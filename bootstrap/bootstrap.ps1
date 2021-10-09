function setRegistryDword {
    param([string]$path, [string]$name, $value)

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

function enableWindowsFeature {
    param([string]$name)

    $featureInfo = Get-WindowsOptionalFeature -Online -FeatureName $name
    if ($featureInfo.State -ne [Microsoft.Dism.Commands.FeatureState]::Enabled -and
            $featureInfo.State -ne [Microsoft.Dism.Commands.FeatureState]::EnablePending) {

        Write-Host "Enable Windows feature '$name'"
        Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName $name
    }
}

$dotPath = "$HOME\.dotfiles"

# Install-PackageProvider -Name NuGet -Force

## Trust the PowerShell Gallery repository
$psGalleryName = "PSGallery"
$psGallery = Get-PSRepository -Name $psGalleryName
if (!$psGallery.Trusted) {
    Set-PSRepository -Name $psGalleryName -InstallationPolicy Trusted
}

## Install PowerShell modules
$psModules = @(
   "posh-git" 
)

foreach ($psModuleName in $psModules) {
    $module = Get-Module -Name $psModuleName
    if ($module -eq $null) {
        Install-Module -Name $psModuleName
    }
}

if ($IsWindows) {
    # should probably do this before symlink step so that any paths to dotfiles already exist
    Write-Host "Installing packages with winget..."
    winget install $dotPath\windows\winget-packages.json

    # Install chocolatey
    if ($null -eq (Get-Command -ErrorAction SilentlyContinue -Name choco)) {
        Write-Host "Installing chocolatey CLI"
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }

    # install choco packages
    Write-Host "Installing packages with chocolatey..."
    choco install -y $dotPath\windows\chocolatey-packages.config

    # is this still needed if installing WSL via wsl.exe?
    $computerInfo = Get-CimInstance -ClassName Win32_ComputerSystem
    if ($computerInfo.Model -eq "Virtual Machine") {
        enableWindowsFeature "Microsoft-Hyper-V-All"
    }

    # Set up aliases if we ever need a cmd prompt
    New-ItemProperty -Force -PropertyType String -Path "HKCU:\Software\Microsoft\Command Processor" `
        -Name AutoRun -Value "$dotPath\windows\win32-rc.cmd"

    # see http://www.experts-exchange.com/OS/Microsoft_Operating_Systems/Windows/A_2155-Keyboard-Remapping-CAPSLOCK-to-Ctrl-and-Beyond.html
    # http://msdn.microsoft.com/en-us/windows/hardware/gg463447.aspx
    $scancodeMapHex = "00,00,00,00,00,00,00,00,02,00,00,00,1d,00,3a,00,00,00,00,00".Split(',') | ForEach-Object { "0x$_" }
    New-ItemProperty -Force -PropertyType Binary -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout" `
        -Name "Scancode Map" -Value ([byte[]]$scancodeMapHex)

    $explorerRegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    $virtualDesktopPinnedAppsRegPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops\PinnedApps"
    $regKeys = @(
        createRegKeyInfo $explorerRegPath "ShowCortanaButton" 0
        createRegKeyInfo $explorerRegPath "HideFileExt" 0
        createRegKeyInfo $explorerRegPath "ShowTaskViewButton" 0
        createRegKeyInfo $explorerRegPath "ShowTaskViewButton" 0
        createRegKeyInfo $virtualDesktopPinnedAppsRegPath "{6D809377-6AF0-444B-8957-A3773F02200E}\ConEmu\ConEmu64.exe" 0
        createRegKeyInfo $virtualDesktopPinnedAppsRegPath "com.squirrel.Teams.Teams" 0
        createRegKeyInfo $virtualDesktopPinnedAppsRegPath "Microsoft.WindowsTerminal_8wekyb3d8bbwe!App" 0
    )

    foreach ($item in $regKeys) {
        setRegistryDword $item.Path $item.Name $item.Value
    }
}

# install vs code extensions 
