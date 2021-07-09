$scriptDir = [System.IO.Path]::GetDirectoryName("$($script:MyInvocation.MyCommand.Definition)")

# Aliases
. "$scriptDir\aliases.ps1"

# Functions
Get-ChildItem -Path $scriptDir\functions -Recurse -File -Include "*.ps1" -ErrorAction SilentlyContinue | ForEach-Object {
    . $_.FullName
}

# Prompt 
function global:prompt {
	$realLASTEXITCODE = $LASTEXITCODE

	$prompt = Write-Prompt "$env:USERNAME@$env:COMPUTERNAME " -ForegroundColor DarkCyan

	$path = ""
	if ($pwd.ProviderPath -eq $env:USERPROFILE) {
		$path = "~"
	} else {
		$parentDirPath = [System.IO.Path]::GetDirectoryName($pwd.ProviderPath)
		$childDir = [System.IO.Path]::GetFileName($pwd.ProviderPath)
		if ($parentDirPath -eq $env:USERPROFILE) {
			$path = "~\$childDir"
		} else {
			$path = "$([System.IO.Path]::GetFileName($parentDirPath))\$childDir"
		}
	}

	$prompt += Write-Prompt $path -ForegroundColor Yellow
	$prompt += Write-Prompt "  " -ForegroundColor Gray
	$prompt += Write-Prompt "$(Get-Date -uFormat "%H:%M:%S")" -ForegroundColor DarkCyan
	$prompt += & $GitPromptScriptBlock

	$global:LASTEXITCODE = $realLASTEXITCODE

	return $prompt
}

# PSReadline configuration
Set-PSReadlineOption -EditMode Emacs
Set-PSReadlineKeyHandler -Key Ctrl+LeftArrow -Function BackwardWord 
Set-PSReadlineKeyHandler -Key Ctrl+RightArrow -Function ForwardWord 
Set-PSReadlineKeyHandler -Key Ctrl+Backspace -Function BackwardKillWord
Set-PSReadlineKeyHandler -Key Escape -Function RevertLine
Set-PSReadLineOption -HistorySearchCursorMovesToEnd 
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

if ((Get-Module -Name PSReadline).Version.Major -lt 2)
{
    Set-PSReadlineOption -TokenKind Parameter -ForegroundColor DarkMagenta
    Set-PSReadlineOption -TokenKind Operator -ForegroundColor DarkMagenta
}
else
{
    Set-PSReadLineOption -Colors @{
        "Parameter" = [System.ConsoleColor]::DarkMagenta;
        "Operator" = [System.ConsoleColor]::DarkMagenta;
    }
}

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process

Import-Module posh-git

$GitPromptSettings.DefaultPromptPath = ""
$GitPromptSettings.DefaultPromptBeforeSuffix.Text = "`n"

$localConfigPath = ".\\localConfig.ps1"
if ((Test-Path $localConfigPath))
{
	. $localConfigPath
}
