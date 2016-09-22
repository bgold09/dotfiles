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

# Enable history 
# http://blogs.msdn.com/b/powershell/archive/2006/07/01/perserving-command-history-across-sessions.aspx
$MaximumHistoryCount = 1KB
$histdir = "~\Documents\WindowsPowerShell"
$histfile = "$histdir\history.csv"

if (!(Test-Path $histdir -PathType Container)) {   
	New-Item $histdir -ItemType Directory
}

function bye {
	Get-History -Count 1KB | Export-CSV $histfile
	exit 
}

if (Test-path $histdir\History.csv) {
	Import-CSV $histfile | Add-History
}

# PSReadline configuration
Set-PSReadlineOption -TokenKind Parameter -ForegroundColor DarkMagenta
Set-PSReadlineOption -TokenKind Operator -ForegroundColor DarkMagenta
Set-PSReadLineOption -HistorySearchCursorMovesToEnd 
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadlinekeyHandler -Function MenuComplete -Key Ctrl+Q

Import-Module posh-git

# Cleanup for git prompt
Pop-Location

