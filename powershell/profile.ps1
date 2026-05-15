$script:scriptDir = [System.IO.Path]::GetDirectoryName("$($script:MyInvocation.MyCommand.Definition)")

# When Windows PowerShell 5.1 is launched from PowerShell 7 (pwsh), it inherits
# PSModulePath entries pointing to PS7-only modules compiled for .NET Core.
# Windows PowerShell cannot load those assemblies, which breaks core modules
# like Microsoft.PowerShell.Security (Cert: drive, Set-ExecutionPolicy) and
# Microsoft.PowerShell.Utility (Import-PowerShellDataFile). Strip them early.
if ($PSVersionTable.PSEdition -eq 'Desktop') {
    $env:PSModulePath = ($env:PSModulePath -split ';' |
        Where-Object { $_ -notmatch '[\\\/]powershell[\\\/]7[\\\/]' }) -join ';'
}

# Aliases
. "$script:scriptDir/aliases.ps1"

# Functions
Get-ChildItem -Path $script:scriptDir/functions -Recurse -File -Include "*.ps1" -ErrorAction SilentlyContinue | ForEach-Object {
    . $_.FullName
}

$script:ansiEscape = "$([char]27)["

function script:getTermColor {
    param ($hex, $fg, $consoleColor)

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
    Red     = getTermColor 0xdc322f 31 Red
    Orange  = getTermColor 0xcb4b16
    Yellow  = getTermColor 0xb58900 33 DarkYellow
    Green   = getTermColor 0x859900 32 DarkGreen
    Blue    = getTermColor 0x268bd2 34 DarkBlue
    Cyan    = getTermColor 0x2aa198 36 DarkCyan
    Violet  = getTermColor 0x6c71c4 95 Magenta
    Magenta = getTermColor 0xd33682 35 DarkMagenta

    Base00  = getTermColor 0x657b83
    Base01  = getTermColor 0x586e75
    Base02  = getTermColor 0x073642
    Base03  = getTermColor 0x002b36

    Base0   = getTermColor 0x839496
    Base1   = getTermColor 0x93a1a1
    Base2   = getTermColor 0xeee8d5
    Base3   = getTermColor 0xfdf6e3
}

function Format-Duration {
    param([TimeSpan]$duration)

    $minutes = [math]::Floor($duration.TotalMinutes)
    $seconds = $duration.Seconds

    if ($minutes -gt 0) {
        return "${minutes}m${seconds}s"
    }

    if ($seconds -gt 0) {
        return "${seconds}s"
    }

    return "$([math]::Round($duration.TotalMilliseconds))ms"
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

    $lastCmd = Get-History -Count 1
    if ($lastCmd -and $lastCmd.Id -ne $script:LastHistoryId) {
        $script:LastHistoryId = $lastCmd.Id
        if ($lastCmd.Duration.TotalMilliseconds -ge 2000) {
            $prompt += colorPromptText $colors.Blue " ($(Format-Duration $lastCmd.Duration))"
        }
    }

    $prompt += & $GitPromptScriptBlock

	$global:LASTEXITCODE = $realLASTEXITCODE

    # Emit OSC 9;9 so Windows Terminal tracks the current directory.
    # This enables new panes/tabs to inherit the current working directory.
    if ($env:WT_SESSION -and $pwd.Provider.Name -eq "FileSystem") {
        $Host.UI.Write("$([char]27)]9;9;`"$($pwd.ProviderPath)`"`a")
        # Write CWD to temp file so split panes with different profiles can inherit it.
        [System.IO.File]::WriteAllText([System.IO.Path]::Combine($env:TEMP, '.terminal-cwd'), $pwd.ProviderPath)
    }

	return $prompt
}

# PSReadline configuration
Set-PSReadlineOption -EditMode Emacs -BellStyle None
Set-PSReadlineKeyHandler -Key Ctrl+LeftArrow -Function BackwardWord 
Set-PSReadlineKeyHandler -Key Ctrl+RightArrow -Function ForwardWord 
Set-PSReadlineKeyHandler -Key Ctrl+Backspace -Function BackwardKillWord
Set-PSReadLineKeyHandler -Key Ctrl+w -Function BackwardKillWord
Set-PSReadlineKeyHandler -Key Escape -Function RevertLine
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Ctrl+g -Function ViEditVisually

# Map Alt+Enter to AddLine so that Shift+Enter works for multi-line editing
# in PSReadLine. Windows Terminal sends \e\r (ESC + CR) for Shift+Enter via
# sendInput action (configured by Copilot CLI's /terminal-setup), and
# PSReadLine interprets \e<key> as Alt+<key>.
Set-PSReadLineKeyHandler -Key Alt+Enter -Function AddLine

if ((Get-Module PSReadLine).Version -ge [version]::new(2, 2, 6)) {
    Set-PSReadLineOption -PredictionSource None
}

if ($PSVersionTable.PSEdition -ne 'Desktop') {
    Set-PSReadLineOption -PredictionSource None
}

Set-PSReadLineOption -Colors @{
    Command = $colors.Yellow.termColor
    Comment = $colors.Base00.xterm
    Error = $colors.Red.termColor
    Keyword = $colors.Green.termColor
    Operator = $colors.Magenta.termColor
    Parameter = $colors.Magenta.termColor
    String = $colors.Cyan.termColor
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

if ($env:WT_SESSION) {
    $editor = "nvim"
} else {
    $editor = "neovide"
    $env:GIT_PAGER = 'less -RFSX'
}

$env:GIT_EDITOR = $editor
$env:EDITOR = $editor

if (Get-Module -ListAvailable -Name Terminal-Icons) {
    Import-Module Terminal-Icons
} else {
    Write-Warning "Terminal-Icons module not found; skipping import."
}

if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })
} else {
    Write-Warning "zoxide not found; skipping initialization."
}

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
