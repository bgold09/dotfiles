$script:scriptDir = [System.IO.Path]::GetDirectoryName("$($script:MyInvocation.MyCommand.Definition)")

# Aliases
. "$script:scriptDir/aliases.ps1"

# Functions
Get-ChildItem -Path $script:scriptDir/functions -Recurse -File -Include "*.ps1" -ErrorAction SilentlyContinue | ForEach-Object {
    . $_.FullName
}

$script:ansiEscape = "$([char]27)["

function script:getTermColor {
    param ($hex, $xterm, $fg, $consoleColor) 

    return [PSCustomObject]@{
        xterm = "$($ansiEscape)$($fg)m"
        hex = $hex
        termColor = $consoleColor
    }
}

function script:colorPromptText {
    param ($color, $text)

    return Write-Prompt "$($color.xterm)$text$($ansiEscape)m"
}

$script:colors = [PSCustomObject]@{
    Red     = getTermColor 0xdc322f 160 31 Red
    Orange  = getTermColor 0xcb4b16 166
    Yellow  = getTermColor 0xb58900 136 33 DarkYellow
    Green   = getTermColor 0x859900 64  32 DarkGreen
    Blue    = getTermColor 0x268bd2 33  34 DarkBlue
    Cyan    = getTermColor 0x2aa198 37  36 DarkCyan
    Violet  = getTermColor 0x6c71c4 61  95 Magenta
    Magenta = getTermColor 0xd33682 125 35 DarkMagenta

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
$dirSep = [System.IO.Path]::DirectorySeparatorChar
function global:prompt {
	$realLASTEXITCODE = $LASTEXITCODE

    $prompt = colorPromptText $colors.Blue "$([Environment]::UserName)@$([Environment]::MachineName) "

	$path = ""
    if ($pwd.ProviderPath -eq $HOME) {
		$path = "~"
	} else {
		$parentDirPath = [System.IO.Path]::GetDirectoryName($pwd.ProviderPath)
		$childDir = [System.IO.Path]::GetFileName($pwd.ProviderPath)
        if ($parentDirPath -eq $HOME) {
            $path = "~$dirSep$childDir"
        } else {
            $path = "$([System.IO.Path]::GetFileName($parentDirPath))$dirSep$childDir"
		}
	}

    $prompt += colorPromptText $colors.Yellow "$path"
    $prompt += colorPromptText $colors.Base1 "  "
    $prompt += colorPromptText $colors.Blue "$(Get-Date -uFormat "%H:%M:%S")"
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

Set-PSReadLineOption -Colors @{
    Command = $colors.Yellow.termColor
    Comment = $colors.Base00.xterm
    Error = $colors.Red.termColor
    Keyword = $colors.Green.termColor
    Operator = $colors.Magenta.termColor
    Parameter = $colors.Magenta.termColor
    String = $colors.Blue.termColor
    Variable = $colors.Green.termColor
}

if ($IsWindows -or $PSVersionTable.PSEdition -eq "Desktop") {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
}

Import-Module posh-git
$GitPromptSettings.BranchColor.ForegroundColor = $colors.Cyan.xterm
$GitPromptSettings.BranchAheadStatusSymbol.ForegroundColor = $colors.Green.xterm
$GitPromptSettings.BranchBehindAndAheadStatusSymbol.ForegroundColor = $colors.Yellow.xterm
$GitPromptSettings.IndexColor.ForegroundColor = $colors.Cyan.xterm
$GitPromptSettings.BeforeStatus.ForegroundColor = [ConsoleColor]::Gray
$GitPromptSettings.AfterStatus.ForegroundColor = [ConsoleColor]::Gray
$GitPromptSettings.DelimStatus.ForegroundColor = [ConsoleColor]::Gray

$GitPromptSettings.DefaultPromptPath = ""
$GitPromptSettings.DefaultPromptBeforeSuffix.Text = "`n"

if ($IsWindows -or $PSVersionTable.PSEdition -eq "Desktop") {
    Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
        param($wordToComplete, $commandAst, $cursorPosition)
            [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
            $Local:word = $wordToComplete.Replace('"', '""')
            $Local:ast = $commandAst.ToString().Replace('"', '""')
            winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
                [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
            }
    }
}

$script:localConfigPath = "./localConfig.ps1"
if ((Test-Path $localConfigPath))
{
	. $localConfigPath
}
