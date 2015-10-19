# Aliases
(new-item alias:npp -value 'C:\Program Files (x86)\Notepad++\notepad++.exe') > Out-Null
(new-item alias:which -value 'Get-Command') > Out-Null
(new-item alias:g -value 'git') > Out-Null
(new-item alias:gvim -value 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Vim 7.4\gvim.lnk') > Out-Null

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
