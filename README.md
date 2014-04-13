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

## Thanks to...

* [Ben Alman](http://benalman.com/) for his [dotfiles repository](https://github.com/cowboy/dotfiles) and [spark tool] (https://github.com/holman/spark)
* [Zach Holman](http://zachholman.com/) for his [dotfiles repository](https://github.com/holman/dotfiles)
* Brett Smith for [dtrx](http://brettcsmith.org/2007/dtrx)

## License

Copyright (c) 2014 Brian Golden
Licensed under the MIT license. 
