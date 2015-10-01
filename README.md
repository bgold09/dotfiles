# dotfiles

These are my dotfiles, which includes configurations for [bash](https://www.gnu.org/software/bash/bash.html), [vim](http://vim.org), [git](http://git-scm.org), [python](http://python.org) and [tmux](http://tmux.sourceforge.net).

## Installation

### Quick installation:

Use the [install file](https://github.com/bgold09/dotfiles/blob/master/install.sh):

```sh
curl --fsSL https://raw.github.com/bgold09/dotfiles/master/install.sh | sh
```

### Using Git and the bootstrap script

Clone this repository:

```sh
git clone https://github.com/bgold09/dotfiles.git ~/.dotfiles 
```

Install the configuration:

```sh
cd ~/.dotfiles
./bootstrap.sh
```

This script will symlink config files to your home directory and install dependent packages using:
* apt-get on Ubuntu
* [homebrew](https://github.com/Homebrew/homebrew) on OSX
* [apt-cyg](https://github.com/transcode-open/apt-cyg) on Cygwin

Each run of the [bootstrap script](https://github.com/bgold09/dotfiles/blob/master/bootstrap.sh) may also require you to re-source your ```bashrc``` and run the following to install vim plugins:

```sh
vim +PluginInstall +qall
```

### Completing the configuration
* Install the [solarized](http://ethanschoonover.com/solarized) colorscheme for your terminal emulator of choice.
* Install the [patched Consolas font for Powerline/Airline](https://github.com/eugeii/consolas-powerline-vim).
* For parallel installation of vim plugins, install the proper version of python or ruby for your build of vim (see ```:help ruby-dynamic``` or ```:help python-dynamic``` for more information).
* Add the following line to your ```.localrc```: ```export SOLARIZED='on'```
* If you plan to use gVim for Windows, install [git](http://git-scm.org) and choose the option 'Use Git from the Windows Command Prompt' during installation.

## What's Inside

* ```bash``` - aliases, completion, prompt and other tweaks
* ```bin``` - any executables here will be added to your ```$PATH``` and be available anywhere (UNIX)
* ```bin-windows``` - any executables here will be added to your ```$PATH``` and be available anywhere (Windows)
* ```cygwin``` - configuraton for Cygwin and Mintty
* ```git``` - nice gitconfig and global gitignore
* ```osx``` - set sensible defaults for OS X
* ```python``` - tab completion for the interpreter, history, command editing
* ```script``` - helpers for installation of these dotfiles
* ```system``` - files here will not be linked in ```home```
* ```tmux``` - configuration for tmux
* ```vim``` - a lot of vimrc tweaks, including the following plugins managed by [vim-plug]:
    * [airline] - statusline/tabline for vim
    * [ag.vim] - vim plugin for the [silver_searcher]
    * [better-whitespace] - better whitespace highlighting
    * [bookmarks] - allows toggling bookmarks per line
    * [closetag] - close open HTML/XML tags
    * [CtrlP] - full path fuzzy file, buffer, mru, tag, ... finder
    * [ctrlp-funky] - navigate and jump to function definitions using CtrlP
    * [delimitMate] - auto-completion for quotes, brackets, etc.
    * [DetectIndent] - detect the indentation settings for an open file
    * [fugitive] - git wrapper
    * [gitgutter] - shows a git diff in the gutter (sign column) and stages/reverts hunks
    * [gitv] - Git repository viewer
    * [gtfo] - opens the file manager or terminal at the directory of the current file
    * [Gundo] - visualization of the vim undo tree
    * [json] - syntax highlighting for JSON
    * [matchit] - match '%' to more than just single characters
    * [multiple-cursors] - Sublime Text style multiple selections
    * [NERDTree] - directory tree explorer
    * [ps1] - PowerShell syntax highlighting for vim
    * [solarized] - precision colorscheme
    * [supertab] - allows you to use &lt;Tab&gt; for insert completion
    * [surround] - delete, add, change surroundings (brackets, quotes, etc.)
    * [Tagbar] - browse tags in source code
    * [targets] - provides additional text objects
    * [tComment] - provides easy to use, file-type sensible comments
    * [unimpaired] - pairs of handy bracket mappings
    * [visual-star-search] - star search for Visual mode
    * [yankstack] - provides a history of yank buffers
* ```windows``` - environment for Windows CMD

[vim-plug]: https://github.com/junegunn/vim-plug
[airline]: https://github.com/bling/vim-airline
[ag.vim]: https://github.com/rking/ag.vim
[bookmarks]: https://github.com/MattesGroeger/vim-bookmarks
[better-whitespace]: https://github.com/ntpeters/vim-better-whitespace
[silver_searcher]: https://github.com/ggreer/the_silver_searcher
[closetag]: https://github.com/vim-scripts/closetag.vim
[CtrlP]: https://github.com/ctrlpvim/ctrlp.vim
[ctrlp-funky]: https://github.com/tacahiroy/ctrlp-funky
[delimitMate]: https://github.com/raimondi/delimitmate
[DetectIndent]: https://github.com/ciaranm/detectindent
[fugitive]: https://github.com/tpope/vim-fugitive
[gitgutter]: https://github.com/airblade/vim-gitgutter
[gitv]: https://github.com/gregsexton/gitv
[gtfo]: https://github.com/justinmk/vim-gtfo
[Gundo]: https://github.com/sjl/gundo.vim
[json]: https://github/com/elzr/vim-json
[matchit]: https://github.com/tmhedberg/matchit
[multiple-cursors]: https://github.com/terryma/vim-multiple-cursors
[NERDTree]: https://github.com/scrooloose/nerdtree
[ps1]: https://github.com/pprovost/vim-ps1
[solarized]: https://github.com/altercation/vim-colors-solarized
[supertab]: https://github.com/ervandew/supertab
[surround]: https://github.com/tpope/vim-surround
[Tagbar]: https://github.com/majutsushi/tagbar
[targets]: https://github.com/wellle/targets.vim
[tComment]: https://github.com/tomtom/tcomment_vim
[unimpaired]: https://github.com/tpope/vim-unimpaired
[visual-star-search]: https://github.com/bronson/vim-visual-star-search
[yankstack]: https://github.com/maxbrunsfeld/vim-yankstack

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
