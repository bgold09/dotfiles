# dotfiles

These are my dotfiles, which includes configurations for [bash](https://www.gnu.org/software/bash/bash.html),
[vim](http://vim.org), [git](http://git-scm.org), and [powershell](https://docs.microsoft.com/en-us/powershell/scripting/overview).

## Installation

### Windows

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force ; `
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072 ; `
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/bgold09/dotfiles/master/install.ps1'))
```

### Linux/OSX

Use the [install file](https://github.com/bgold09/dotfiles/blob/master/install.sh):

```sh
curl -fsSL https://raw.githubusercontent.com/bgold09/dotfiles/master/install.sh | sh
```

Each run of the [bootstrap script](https://github.com/bgold09/dotfiles/blob/master/bootstrap.sh) may also require you to re-source your ```bashrc``` and run the following to install vim plugins:

```sh
vim +PlugInstall +qall
```

### Completing the configuration

* Patch Consolas using the font patcher distributed with [nerd-fonts](https://github.com/ryanoasis/nerd-fonts).
  Due to licensing, Consolas cannot be distributed in its patched form.
* Add the following line to your ```.localrc```: ```export SOLARIZED='on'```

## What's Inside

* ```bash``` - aliases, completion, prompt and other tweaks
* ```bin``` - executables here will be added to your ```$PATH``` and be available anywhere (UNIX)
* ```bin-windows``` - executables here will be added to your ```$PATH``` and be available anywhere (Windows)
* ```git``` - nice gitconfig and global gitignore
* ```osx``` - set sensible defaults for OS X
* ```powershell``` - aliases, functions and custom prompt
* ```python``` - tab completion for the interpreter, history, command editing
* ```script``` - helpers for installation of these dotfiles
* ```system``` - files here will be symlinked to ```home```
* ```tmux``` - configuration for tmux
* ```vim``` - a lot of vimrc tweaks, including the following plugins managed by [vim-plug]:
* ```windows``` - environment for Windows CMD

## Customization

To customize your installation, create any of the following files in your home directory and make the desired changes:
* ```.bootstrap.exclusions```: add the names of any configurations you would like to skip during installation (one per line)
* ```.localrc```: configure bash; add/remove aliases, define functions, etc. 
* ```.plugins.local.vim```: add Vundle ```Plugin``` lines to add more vim plugins, or use the ```UnBundle``` command defined in [```plugins.vim```](https://github.com/bgold09/dotfiles/blob/master/vim/plugins.vim) to disable plugins 

## Thanks to...

* [David Jenni](https://github.com/davidjenni) for his [dotfiles repository and bootstrapping for Windows CMD](https://github.com/davidjenni/dotfiles)
* [Ben Alman](http://benalman.com/) for his [dotfiles repository](https://github.com/cowboy/dotfiles) and [spark tool] (https://github.com/holman/spark)
* [Zach Holman](http://zachholman.com/) for his [dotfiles repository](https://github.com/holman/dotfiles)
* [Mathias Bynens](http://mathiasbynens.be/) for his [OSX defaults script](https://github.com/mathiasbynens/dotfiles/blob/master/.osx)
* [Doug Black](http://dougblack.io/words/a-good-vimrc.html) for his [vim setup](http://dougblack.io/words/a-good-vimrc.html)
* [Steve Francia](http://spf13.com/) for his [vim setup](http://spf13.com/post/ultimate-vim-config/)
* Brett Smith for [dtrx](http://brettcsmith.org/2007/dtrx)

## License

Copyright (c) 2014 Brian Golden

Licensed under the MIT license. 
