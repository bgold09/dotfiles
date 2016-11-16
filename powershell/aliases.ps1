# Aliases
(new-item alias:npp -value 'C:\Program Files (x86)\Notepad++\notepad++.exe') > Out-Null
(new-item alias:which -value 'Get-Command') > Out-Null
(new-item alias:g -value 'git') > Out-Null
(new-item alias:vi -value 'gvim') > Out-Null
(new-item alias:ll -value 'Get-ChildItem') > Out-Null

# Alias functions
function dot {
	 cd $env:USERPROFILE\.dotfiles
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
	cd $(git rev-parse --show-cdup)
}

function vup {
	gvim +PlugUpdate
}

function vi {
	gvim --remote-silent $args
}
