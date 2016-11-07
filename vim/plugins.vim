function! Cond(cond, ...)
	let opts = get(a:000, 0, {})
	return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

silent function! WINDOWS()
	return (has('win16') || has('win32') || has('win64'))
endfunction

silent function! Executable_Ctags()
	return (executable('ctags') || executable('ctags-exuberant'))
endfunction

if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
	    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')

" colors {{{
Plug 'altercation/vim-colors-solarized'
" }}}
" syntax & languages {{{
Plug 'godlygeek/tabular' | Plug 'plasticboy/vim-markdown'
Plug 'elzr/vim-json'
Plug 'pprovost/vim-ps1'
Plug 'ciaranm/detectindent'
Plug 'docunext/closetag.vim'
Plug 'leafgarland/typescript-vim'
Plug 'OrangeT/vim-csharp'
Plug 'pangloss/vim-javascript'
" }}}
" interface {{{
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'ctrlpvim/ctrlp.vim' | Plug 'tacahiroy/ctrlp-funky' | Plug 'sgur/ctrlp-extensions.vim'
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
Plug 'ervandew/supertab'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive' | Plug 'gregsexton/gitv'
Plug 'justinmk/vim-gtfo'
Plug 'junegunn/goyo.vim'

Plug 'majutsushi/tagbar', Cond(Executable_Ctags())
Plug 'xolox/vim-misc', Cond(Executable_Ctags()) | Plug 'xolox/vim-shell' | Plug 'xolox/vim-easytags'

Plug 'sjl/gundo.vim', Cond(has('python'))
Plug 'mileszs/ack.vim', Cond(executable('ag'))
" }}}
" integration {{{
	Plug 'tpope/vim-dispatch'
" }}}
" movement {{{
Plug 'tmhedberg/matchit'
Plug 'tpope/vim-unimpaired'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'bronson/vim-visual-star-search'
Plug 'justinmk/vim-sneak'
" }}}
" editing {{{
Plug 'tomtom/tcomment_vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'raimondi/delimitmate'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'
Plug 'terryma/vim-multiple-cursors'
" }}}

" Add or unbundle plugins in a local plugin config 
if filereadable(expand("~/.plugins.local.vim"))
	source ~/.plugins.local.vim
endif

call plug#end()

" airline {{{
	let g:airline_powerline_fonts = 1
	let g:airline_theme = 'solarized'
	let g:airline#extensions#tabline#enabled = 1
	let g:airline#extensions#tabline#fnamemod = ':t'
	let g:airline#extensions#whitespace#enabled = 0
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
" ack.vim {{{
	if executable('ag')
		let g:ackprg='ag --nogroup --nocolor --column'
		nnoremap <leader>a :Ack 
		set grepprg=ag\ --nogroup\ --nocolor
	endif
" }}}
" bookmarks {{{
 	if WINDOWS() || has('win32unix')
		" TODO: remove after signs issue is resolved for Windows
		let g:bookmark_sign = '>>'
		let g:bookmark_annotation_sign = '##'
	endif
" }}}
" better-whitespace {{{
	let g:better_whitespace_enabled = 0
" }}}
	" closetag {{{
	autocmd FileType html,htmldjango,jinjahtml,eruby,mako let b:closetag_html_style=1
	autocmd FileType html,xhtml,xml,htmldjango,eruby,mako source ~/.vim/bundle/closetag.vim/plugin/closetag.vim
" }}}
" CtrlP {{{
	nnoremap <C-M> :CtrlPMRUFiles<CR>

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
" easytags {{{
	let g:easytags_async = 1
	let g:easytags_dynamic_files = 1
	let g:easytags_events = [ 'BufWritePost' ]
" }}}
" gtfo {{{
	let g:gtfo#terminals = { 'win' : 'cmd' }
" }}}
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
	map <C-t> :NERDTreeToggle<CR>
" }}}
" solarized {{{
	let g:solarized_termcolors=256
	let g:solarized_termtrans=1
	colorscheme solarized
	call togglebg#map("<F5>")
" }}}
" SuperTab {{{
	let g:SuperTabDefaultCompletionType = 'context'
" }}}
" Tagbar {{{
	if Executable_Ctags()
		let g:tagbar_usearrows = 1
		nnoremap <leader>l :TagbarToggle<CR>
	endif
" }}}

" vim:foldmethod=marker:foldlevel=0
