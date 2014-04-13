# dotfiles

These are my dotfiles, which includes configurations for [bash], [vim], [git] and [python].

[bash]: https://www.gnu.org/software/bash/bash.html
[vim]: http://www.vim.org
[git]: http://git-scm.com 
[python]: http://www.python.org

## Installation

### Quick installation:

```sh
curl --fsSL https://github.com/bgold09/dotfiles.git | sh
```

### Using Git and the bootstrap script

Clone this repository and submodules:

```sh
git clone --recursive https://github.com/bgold09/dotfiles.git ~/.dotfiles 
```

Install the configuration (create links):

```sh
cd ~/.dotfiles
./bootstrap.sh
```
