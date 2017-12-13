Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# Aliases
. .\aliases.ps1

# Functions
. .\functions.ps1

# Prompt 
function global:prompt {
	$realLASTEXITCODE = $LASTEXITCODE

	Write-Host("$env:USERNAME@$env:COMPUTERNAME ") -nonewline -ForegroundColor Green

	$path = ""
	if ($pwd.ProviderPath -eq $env:USERPROFILE) {
		$path = "~"
	} else {
		$childDir = $pwd.ProviderPath | Split-Path -Leaf
		$parentDirPath = Split-Path -Path $pwd.ProviderPath -Parent
		if ($parentDirPath -eq $env:USERPROFILE) {
			$path = "~\$childDir"
		} else {
			$path = "$($parentDirPath | Split-Path -Leaf)\$childDir"
		}
	}

	Write-Host($path) -NoNewline -ForegroundColor Yellow
	Write-VcsStatus
	Write-Host("  ") -ForegroundColor Gray -NoNewline
	Write-Host("$(Get-Date -uFormat "%H:%M:%S")") -ForegroundColor DarkCyan

	$global:LASTEXITCODE = $realLASTEXITCODE
	return "> "
}

# PSReadline configuration
Set-PSReadlineOption -EditMode Emacs
Set-PSReadlineKeyHandler -Key Ctrl+LeftArrow -Function BackwardWord 
Set-PSReadlineKeyHandler -Key Ctrl+RightArrow -Function ForwardWord 
Set-PSReadlineKeyHandler -Key Ctrl+Backspace -Function BackwardKillWord
Set-PSReadlineKeyHandler -Key Escape -Function RevertLine
Set-PSReadlineOption -TokenKind Parameter -ForegroundColor DarkMagenta
Set-PSReadlineOption -TokenKind Operator -ForegroundColor DarkMagenta
Set-PSReadLineOption -HistorySearchCursorMovesToEnd 
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadlinekeyHandler -Function MenuComplete -Key Ctrl+Q

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process

Import-Module posh-git

$localConfigPath = ".\\localConfig.ps1"
if ((Test-Path $localConfigPath))
{
	. $localConfigPath
}

# Cleanup for git prompt
Pop-Location
