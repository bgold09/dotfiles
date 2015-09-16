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

filetype off
set rtp+=$HOME/.vim/bundle/vundle

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

filetype plugin indent on

" airline {{{
	let g:airline_powerline_fonts = 1
	let g:airline_theme = 'solarized'
	let g:airline#extensions#tabline#enabled = 1
	let g:airline#extensions#tabline#fnamemod = ':t'
	set laststatus=2
	set timeoutlen=1000 ttimeoutlen=0
	if !exists('g:airline_symbols')
		let g:airline_symbols = {}
	endif
	let g:airline_symbols.space= "\ua0"
	let g:airline_left_sep = "\u2b80" "use double quotes here
	let g:airline_left_alt_sep = "\u2b81"
	let g:airline_right_sep = "\u2b82"
	let g:airline_right_alt_sep = "\u2b83"
	let g:airline_symbols.branch = "\u2b60"
	let g:airline_symbols.readonly = "\u2b64"
	let g:airline_symbols.linenr = "\u2b61"
" }}} 
" ag {{{
	if executable('ag')
		nnoremap <leader>a :Ag
		set grepprg=ag\ --nogroup\ --nocolor
	endif
" }}}
	" closetag {{{
	autocmd FileType html,htmldjango,jinjahtml,eruby,mako let b:closetag_html_style=1
	autocmd FileType html,xhtml,xml,htmldjango,eruby,mako source ~/.vim/bundle/closetag.vim/plugin/closetag.vim
" }}}
" CtrlP {{{
	let g:ctrlp_match_window = 'bottom,order:ttb'
	if WINDOWS()
		let s:ctrlp_fallback = 'dir %s /-n /b /s /a-d'
	elseif executable('ag')
		let s:ctrlp_fallback = 'ag %s -l --nocolor --hidden -g ""'
	else
		let s:ctrlp_fallback = 'find %s -type f'
	endif

	let g:ctrlp_user_command = {
		\ 'types': {
			\ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
			\ 2: ['.hg', 'hg --cwd %s locate -I .'],
		\ },
		\ 'fallback': s:ctrlp_fallback	
	\ }
"}}}
" vim-json {{{
	let g:vim_json_syntax_conceal = 0
" }}}
" Fugitive {{{
	nnoremap <silent> <leader>gs :Gstatus<CR>
	nnoremap <silent> <leader>gd :Gdiff<CR>
	nnoremap <silent> <leader>gc :Gcommit<CR>
"}}}
" Gundo {{{ 
	if v:version >= '703' || has('python')
		nnoremap <leader>u :GundoToggle<CR>
	endif
" }}}
" NERDTree {{{
	map <C-n> :NERDTreeToggle<CR>
" }}}
" solarized {{{
	let g:solarized_termcolors=256
	let g:solarized_termtrans=1
	colorscheme solarized
" }}}
" SuperTab {{{
	let g:SuperTabDefaultCompletionType = 'context'
" }}}
" Tagbar {{{
	if executable('ctags-exuberant')
		let g:tagbar_usearrows = 1
		nnoremap <leader>l :TagbarToggle<CR>
	endif
" }}}
" Yankstack {{{
	nmap <leader>p <Plug>yankstack_substitute_older_paste
	nmap <leader>P <Plug>yankstack_substitute_newer_paste
" }}}

" vim:foldmethod=marker:foldlevel=0
