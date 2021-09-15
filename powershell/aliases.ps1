# Aliases
New-Alias -Name g -Value git
New-Alias -Name which -Value Get-Command
New-Alias -Name vi -Value gvim
New-Alias -Name ll -Value Get-ChildItem

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
    Set-Location (git rev-parse --show-toplevel)
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
