silent function! WINDOWS()
	return (has('win16') || has('win32') || has('win64'))
endfunction

" Add an UnBundle function 
function! UnBundle(arg, ...)
	let bundle = vundle#config#init_bundle(a:arg, a:000)
	call filter(g:bundles, 'v:val["name_spec"] != "' . a:arg . '"')
endfunction

com! -nargs=+ UnBundle
\ call UnBundle(<args>)


set rtp+=$HOME/.vim/bundle/vundle
if WINDOWS()
	set rtp+=$HOME/vimfiles/bundle/vundle
	let path="~/vimfiles/bundle"
endif

call vundle#begin()

Plugin 'altercation/vim-colors-solarized'
Plugin 'bling/vim-airline'
Plugin 'ciaranm/detectindent'
Plugin 'docunext/closetag.vim'
Plugin 'elzr/vim-json'
Plugin 'ervandew/supertab'
Plugin 'gmarik/vundle'
"" Tabular must come before vim-markdown
Plugin 'godlygeek/tabular'
Plugin 'kien/ctrlp.vim'
Plugin 'maxbrunsfeld/vim-yankstack'
Plugin 'plasticboy/vim-markdown'
Plugin 'pprovost/vim-ps1'
Plugin 'raimondi/delimitmate'
Plugin 'scrooloose/nerdtree'
Plugin 'tmhedberg/matchit'
Plugin 'tomtom/tcomment_vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'

if executable('ctags-exuberant')
	Plugin 'majutsushi/tagbar'
endif

if v:version >= '703' || has('python')
	Plugin 'sjl/gundo.vim'
endif

if executable('ag') 
	Plugin 'rking/ag.vim'
endif

" Add or unbundle plugins in a local plugin config 
if filereadable(expand("~/.plugins.local.vim"))
	source ~/.plugins.local.vim
endif

call vundle#end()
