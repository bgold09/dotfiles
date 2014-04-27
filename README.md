# dotfiles

These are my dotfiles, which includes configurations for [bash], [vim], [git], [python] and [tmux].

[bash]: https://www.gnu.org/software/bash/bash.html
[vim]: http://www.vim.org
[git]: http://git-scm.com 
[python]: http://www.python.org
[tmux]: http://tmux.sourceforge.net

## Installation

### Quick installation:

Use the [install file](https://github.com/bgold09/dotfiles/blob/master/install.sh):

```sh
curl --fsSL https://raw.github.com/bgold09/dotfiles/master/install.sh | sh
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

## What's Inside

* ```bash``` - aliases, completion, prompt and other tweaks
* ```bin``` - any executables here will be added to your ```$PATH``` and be available anywhere
* ```git``` - nice gitconfig and global gitignore
* ```osx``` - set sensible defaults for OS X
* ```python``` - tab completion for the interpreter, history, command editing
* ```script``` - helpers for installation of these dotfiles
* ```system``` - files here will not be linked in ```home```
* ```tmux``` - configuration for tmux
* ```vim``` - a lot of vimrc tweaks, including the following plugins:
    * [ag.vim] - vim plugin for the [silver_searcher]
    * [CtrlP] - full path fuzzy file, buffer, mru, tag, ... finder
    * [DetectIndent] - detect the indentation settings for an open file
    * [fugitive] - git wrapper
    * [Gundo] - visualization of the vim undo tree
    * [matchit] - match '%' to more than just single characters
    * [NERDTree] - directory tree explorer
    * [pathogen] - runtimepath & plugin manager
    * [solarized] - precision colorscheme
    * [supertab] - allows you to use &lt;Tab&gt; for insert completion
    * [surround] - delete, add, change surroundings (brackets, quotes, etc.)
    * [Tagbar] - browse tags in source code
    * [tComment] - provides easy to use, file-type sensible comments
    * [yankstack] - provides a history of yank buffers
* ```windows``` - Windows-specific configurations (Mintty)

[ag.vim]: https://github.com/rking/ag.vim
[silver_searcher]: https://github.com/ggreer/the_silver_searcher
[CtrlP]: https://github.com/kien/ctrlp.vim
[DetectIndent]: https://github.com/ciaranm/detectindent
[fugitive]: https://github.com/tpope/vim-fugitive
[Gundo]: https://github.com/sjl/gundo.vim
[matchit]: https://github.com/tmhedberg/matchit
[NERDTree]: https://github.com/scrooloose/nerdtree
[pathogen]: https://github.com/tpope/vim-pathogen
[solarized]: https://github.com/altercation/vim-colors-solarized
[supertab]: https://github.com/ervandew/supertab
[surround]: https://github.com/tpope/vim-surround
[Tagbar]: https://github.com/majutsushi/tagbar
[tComment]: https://github.com/tomtom/tcomment_vim
[yankstack]: https://github.com/maxbrunsfeld/vim-yankstack

## Thanks to...

* [Ben Alman](http://benalman.com/) for his [dotfiles repository](https://github.com/cowboy/dotfiles) and [spark tool] (https://github.com/holman/spark)
* [Zach Holman](http://zachholman.com/) for his [dotfiles repository](https://github.com/holman/dotfiles)
* [Mathias Bynens](http://mathiasbynens.be/) for his [OSX defaults script](https://github.com/mathiasbynens/dotfiles/blob/master/.osx)
* [Doug Black](http://dougblack.io/words/a-good-vimrc.html) for his [vim setup](http://dougblack.io/words/a-good-vimrc.html)
* [Steve Francia](http://spf13.com/) for his [vim setup](http://spf13.com/post/ultimate-vim-config/)
* Brett Smith for [dtrx](http://brettcsmith.org/2007/dtrx)

## License

Copyright (c) 2014 Brian Golden
Licensed under the MIT license. 
