# Aliases
(new-item alias:which -value 'Get-Command') > Out-Null
(new-item alias:g -value 'git') > Out-Null
(new-item alias:vi -value 'gvim') > Out-Null
(new-item alias:ll -value 'Get-ChildItem') > Out-Null

# Alias functions
function dot {
	 Set-Location $env:USERPROFILE\.dotfiles
}

function touch([string]$filename) {
	New-Item -Type file $filename
}

function gs {
	git status -sb $args
}

function gc([string]$message) {
	git commit -m $message
}

function ga {
	git add $args
}

function gr {
	$repoRoot = git rev-parse --show-cdup
	if ($repoRoot -ne '') {
		Set-Location $repoRoot
	}
}

function vup {
	gvim +PlugUpdate
}

function vi {
	gvim --remote-silent $args
}

function nvi {
	Invoke-Expression "$env:ChocolateyToolsLocation\neovim\Neovim\bin\nvim-qt.exe --qwindowgeometry 615x575 $args"
}
