# dotfiles

These are my dotfiles, which includes configurations for [bash], [vim], [git] and [python].

[bash]: https://www.gnu.org/software/bash/bash.html
[vim]: http://www.vim.org
[git]: http://git-scm.com 
[python]: http://www.python.org

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
* ```git``` - nice gitconfig
* ```python``` - tab completion for the interpreter, history, command editing
* ```vim``` - a lot of vimrc tweaks, including the following plugins:
    * [ag.vim] - vim plugin for the [silver_searcher]
    * [CtrlP] - full path fuzzy file, buffer, mru, tag, ... finder
    * [fugitive] - git wrapper
    * [Gundo] - visualization of the vim undo tree
    * [matchit] - match '%' to more than just single characters
    * [NERDTree] - directory tree explorer
    * [pathogen] - runtimepath & plugin manager
    * [supertab] - allows you to use &lt;Tab&gt; for insert completion
    * [surround] - delete, add, change surroundings (brackets, quotes, etc.)
    * [Tagbar] - browse tags in source code
    * [tComment] - provides easy to use, file-type sensible comments
    * [yankstack] - provides a history of yank buffers

[ag.vim]: https://github.com/rking/ag.vim
[silver_searcher]: https://github.com/ggreer/the_silver_searcher
[CtrlP]: https://github.com/kien/ctrlp.vim
[fugitive]: https://github.com/tpope/vim-fugitive
[Gundo]: https://github.com/sjl/gundo.vim
[matchit]: https://github.com/tmhedberg/matchit
[NERDTree]: https://github.com/scrooloose/nerdtree
[pathogen]: https://github.com/tpope/vim-pathogen
[supertab]: https://github.com/ervandew/supertab
[surround]: https://github.com/tpope/vim-surround
[Tagbar]: https://github.com/majutsushi/tagbar
[tComment]: https://github.com/tomtom/tcomment_vim
[yankstack]: https://github.com/maxbrunsfeld/vim-yankstack

## Components

There are a few special directories in the repository:
* ```bin``` - any executables here will be added to your ```$PATH``` and be available anywhere
* ```system``` - files here will not be linked in ```home```

## Thanks to...

* [Ben Alman](http://benalman.com/) for his [dotfiles repository](https://github.com/cowboy/dotfiles) and [spark tool] (https://github.com/holman/spark)
* [Zach Holman](http://zachholman.com/) for his [dotfiles repository](https://github.com/holman/dotfiles)
* Brett Smith for [dtrx](http://brettcsmith.org/2007/dtrx)

## License

Copyright (c) 2014 Brian Golden
Licensed under the MIT license. 
