# dotfiles

These are my dotfiles, which includes configurations for
[neovim](http://neovim.io), [git](http://git-scm.org), [powershell](https://docs.microsoft.com/en-us/powershell/scripting/overview), and more.

## Installation

### Windows

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force ; `
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072 ; `
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/bgold09/dotfiles/master/install.ps1'))
```

### Linux/OSX

```sh
curl -fsSL https://raw.githubusercontent.com/bgold09/dotfiles/master/install.sh | sh
```

## What's Inside

* ```bash``` - aliases, completion, prompt and other tweaks
* ```git``` - git aliases and sensible defaults
* ```osx``` - set sensible defaults for OS X
* ```powershell``` - aliases, functions and custom prompt
* ```vim``` - vim and Neovim customizations
* ```windows``` - environment for Windows

## License

Copyright (c) 2014 Brian Golden

Licensed under the MIT license. 
