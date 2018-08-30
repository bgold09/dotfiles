$dotfiles="$env:HOME/.dotfiles"

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

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout" /v "Scancode Map" /d 0000000000000000020000001D003A0000000000 /t REG_BINARY /f > $null
reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun /t REG_SZ /d "$dotfiles/windows/win32-rc.cmd" /f > $null