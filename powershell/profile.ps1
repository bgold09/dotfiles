$scriptDir = [System.IO.Path]::GetDirectoryName("$($script:MyInvocation.MyCommand.Definition)")

# Aliases
. "$scriptDir\aliases.ps1"

# Functions
Get-ChildItem -Path $scriptDir\functions -Recurse -File -Include "*.ps1" -ErrorAction SilentlyContinue | ForEach-Object {
    . $_.FullName
}

function getTermColor {
    param ($value)

    return "`e[38;5;$($value)m"
}

function coloredText {
    param ($color, $text)

    return "$color$text`e[m"
}

$colors = [PSCustomObject]@{
    Red = getTermColor 160
    Orange = getTermColor 166
    Yellow = getTermColor 136
    Green = getTermColor 64
    Blue = getTermColor 33
    Cyan = getTermColor 37
    Violet = getTermColor 61
    Magenta = getTermColor 125

    Base00 = getTermColor 241
    Base01 = getTermColor 240
    Base02 = getTermColor 235
    Base03 = getTermColor 234

    Base0 = getTermColor 244
    Base1 = getTermColor 245
    Base2 = getTermColor 254
    Base3 = getTermColor 230
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

if ($env:WT_SESSION) {
    Set-PSReadLineOption -Colors @{
        Command = $colors.Yellow
        Comment = $colors.Base00
        Error = $colors.Red
        Operator = $colors.Magenta
        Parameter = $colors.Magenta
        String = $colors.Blue
        Variable = $colors.Green
    }
} else {
    Set-PSReadLineOption -Colors @{
        Command = "`e[93m";
        Parameter = "`e[35m";
        Operator = "`e[35m";
    }
}

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process

Import-Module posh-git

$GitPromptSettings.DefaultPromptPath = ""
$GitPromptSettings.DefaultPromptBeforeSuffix.Text = "`n"

Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
        [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
        $Local:word = $wordToComplete.Replace('"', '""')
        $Local:ast = $commandAst.ToString().Replace('"', '""')
        winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}

$localConfigPath = ".\\localConfig.ps1"
if ((Test-Path $localConfigPath))
{
	. $localConfigPath
}
