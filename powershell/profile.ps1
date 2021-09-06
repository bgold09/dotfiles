$scriptDir = [System.IO.Path]::GetDirectoryName("$($script:MyInvocation.MyCommand.Definition)")

# Aliases
. "$scriptDir\aliases.ps1"

# Functions
Get-ChildItem -Path $scriptDir\functions -Recurse -File -Include "*.ps1" -ErrorAction SilentlyContinue | ForEach-Object {
    . $_.FullName
}

function getTermColor {
    param ($hex, $xterm, $fg)

    if ($env:WT_SESSION) {
        $x = "`e[38;5;$($xterm)m"
    } else {
        $x = "`e[$($fg)m"
    }

    return [PSCustomObject]@{
        xterm =  $x
        hex = $hex
    }

    return
}

function coloredText {
    param ($color, $text)

    return "$color$text`e[m"
}

$colors = [PSCustomObject]@{
    Red     = getTermColor 0xdc322f 160 31
    Orange  = getTermColor 0xcb4b16 166
    Yellow  = getTermColor 0xb58900 136 93
    Green   = getTermColor 0x859900 64  33
    Blue    = getTermColor 0x268bd2 33  94
    Cyan    = getTermColor 0x2aa198 37  94
    Violet  = getTermColor 0x6c71c4 61  35
    Magenta = getTermColor 0xd33682 125 95

    Base00  = getTermColor 0x657b83 241
    Base01  = getTermColor 0x586e75 240
    Base02  = getTermColor 0x073642 235
    Base03  = getTermColor 0x002b36 234

    Base0   = getTermColor 0x839496 244
    Base1   = getTermColor 0x93a1a1 245
    Base2   = getTermColor 0xeee8d5 254
    Base3   = getTermColor 0xfdf6e3 230
}

# Prompt 
function global:prompt {
	$realLASTEXITCODE = $LASTEXITCODE

    $prompt = Write-Prompt (coloredText $colors.Blue.xterm "$env:USERNAME@$env:COMPUTERNAME ")

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

    $prompt += Write-Prompt (coloredText $colors.Yellow.xterm "$path")
    $prompt += Write-Prompt (coloredText $colors.Base1.xterm "  ")
    $prompt += Write-Prompt (coloredText $colors.Blue.xterm "$(Get-Date -uFormat "%H:%M:%S")")
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

Import-Module posh-git

if ($env:WT_SESSION) {
    Set-PSReadLineOption -Colors @{
        Command = $colors.Yellow.xterm
        Comment = $colors.Base00.xterm
        Error = $colors.Red.xterm
        Operator = $colors.Magenta.xterm
        Parameter = $colors.Magenta.xterm
        String = $colors.Blue.xterm
        Variable = $colors.Green.xterm
    }

    $GitPromptSettings.BranchColor.ForegroundColor = $colors.Cyan.hex
    $GitPromptSettings.BranchAheadStatusSymbol.ForegroundColor = $colors.Green.hex
    $GitPromptSettings.BranchBehindAndAheadStatusSymbol.ForegroundColor = $colors.Yellow.hex
} else {
    Set-PSReadLineOption -Colors @{
        Command = "`e[93m";
        Parameter = "`e[35m";
        Operator = "`e[35m";
    }
}

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process

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
