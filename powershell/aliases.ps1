# Aliases
New-Alias -Name g -Value git
New-Alias -Name which -Value Get-Command
New-Alias -Name ll -Value Get-ChildItem

# Alias functions
function dot {
	 Set-Location $HOME/.dotfiles
}

function touch([string]$filename) {
	New-Item -Type file $filename
}

function bat {
    bat.exe --pager="less --RAW-CONTROL-CHARS --ignore-case" $args
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

if ($IsWindows -or $PSVersionTable.PSEdition -eq "Desktop") {
    function vi {
        nvim-qt.exe --qwindowgeometry 875x750 $args
    }

    function vup {
        nvim-qt.exe +PlugUpdate
    }
} else {
    New-Alias -Name vi -Value nvim

    function vup {
        nvim +PlugUpdate
    }
}

if ($IsLinux) {
    function apt-get {
        sudo apt-get $args
    }

    function update {
        sudo apt-get update ; sudo apt-get upgrade
    }
}
