Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# Aliases
. .\aliases.ps1

# Functions
. .\functions.ps1

# Prompt 
function global:prompt {
	$realLASTEXITCODE = $LASTEXITCODE

	Write-Host($env:USERNAME + "@" + $env:COMPUTERNAME + " ") -nonewline -ForegroundColor Green
	$parentDir = Split-Path -Path $pwd.ProviderPath -Parent | Split-Path -Leaf
	Write-Host($parentDir + "\") -nonewline -ForegroundColor Yellow
	Write-Host(Split-Path -Path $pwd.ProviderPath -Leaf) -nonewline -ForegroundColor Yellow

	Write-VcsStatus

	$global:LASTEXITCODE = $realLASTEXITCODE
	return " $ "
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

Import-Module posh-git

# Cleanup for git prompt
Pop-Location