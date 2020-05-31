Install-PackageProvider -Name NuGet -Force

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

## Install Windows optional features
$winOptionalFeatures = @(
   "Microsoft-Windows-Subsystem-Linux",
   "Microsoft-Hyper-V-All"
)

foreach ($optionalFeature in $winOptionalFeatures) {
    $featureInfo = Get-WindowsOptionalFeature -Online -FeatureName $optionalFeature
    if ($featureInfo.State -ne [Microsoft.Dism.Commands.FeatureState]::Enabled -and
            $featureInfo.State -ne [Microsoft.Dism.Commands.FeatureState]::EnablePending) {

        Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName $optionalFeature
    }
}

$dotPath = "$env:HOME\.dotfiles"

# Set up aliases if we ever need a cmd prompt
New-ItemProperty -Force -PropertyType REG_SZ -Path "HKCU\Software\Microsoft\Command Processor" `
    -Name AutoRun -Value "$dotPath\windows\win32-rc.cmd"

# see http://www.experts-exchange.com/OS/Microsoft_Operating_Systems/Windows/A_2155-Keyboard-Remapping-CAPSLOCK-to-Ctrl-and-Beyond.html
# http://msdn.microsoft.com/en-us/windows/hardware/gg463447.aspx
New-ItemProperty -Force -PropertyType REG_BINARY -Path "HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout" `
    -Name "Scancode Map" -Value 0000000000000000020000001D003A0000000000
