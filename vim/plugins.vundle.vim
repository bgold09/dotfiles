set rtp+=~/.vim/bundle/vundle/
call vundle#begin()

Plugin 'gmarik/vundle'
Plugin 'tpope/vim-fugitive'
Plugin 'kien/ctrlp.vim'
Plugin 'tomtom/tcomment_vim'
Plugin 'ervandew/supertab'
Plugin 'maxbrunsfeld/vim-yankstack'
Plugin 'tpope/vim-surround'
Plugin 'tmhedberg/matchit'
Plugin 'scrooloose/nerdtree'
Plugin 'ciaranm/detectindent'
Plugin 'altercation/vim-colors-solarized'
Plugin 'docunext/closetag.vim'
Plugin 'raimondi/delimitmate'

if executable('ctags-exuberant')
	Plugin 'majutsushi/tagbar'
endif

if v:version >= '703' || has('python')
	Plugin 'sjl/gundo.vim'
endif

if executable('ag') 
	Plugin 'rking/ag.vim'
endif

call vundle#end()
