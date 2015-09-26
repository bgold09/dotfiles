# Aliases
new-item alias:npp -value 'C:\Program Files (x86)\Notepad++\notepad++.exe'
new-item alias:which -value 'Get-Command'
new-item alias:g -value 'git'
new-item alias:gvim -value 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Vim 7.4\gvim.lnk'

# Alias functions

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

function vup {
	gvim +PlugUpdate
}
