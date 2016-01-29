Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# Aliases
. .\aliases.ps1

# Functions
. .\functions.ps1

# Prompt 
function global:prompt {
	$realLASTEXITCODE = $LASTEXITCODE

	# Reset color, which can be messed up by Enable-GitColors
	$Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

	Write-Host($env:USERNAME + "@" + $env:COMPUTERNAME + " ") -nonewline
	$parentDir = Split-Path -Path $pwd.ProviderPath -Parent | Split-Path -Leaf
	Write-Host($parentDir + "\") -nonewline
	Write-Host(Split-Path -Path $pwd.ProviderPath -Leaf) -nonewline

	Write-VcsStatus

	$global:LASTEXITCODE = $realLASTEXITCODE
	return "> "
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

Install-Module posh-git

# Cleanup for git prompt
Enable-GitColors
Pop-Location

Start-SshAgent -Quiet
