function! Cond(cond, ...)
	let opts = get(a:000, 0, {})
	return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

silent function! WINDOWS()
	return (has('win16') || has('win32') || has('win64'))
endfunction

if empty(glob('~/.vim/autoload/plug.vim'))
    if WINDOWS()
        silent !curl -fLo \%HOME\%/.vim/autoload/plug.vim --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    else
        silent !curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    endif
	autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

silent! call plug#begin('~/.vim/bundle')

" colors {{{
Plug 'lifepillar/vim-solarized8', Cond(!exists('g:vscode'))
" }}}
" syntax & languages {{{
if !exists('g:vscode')
Plug 'godlygeek/tabular' | Plug 'plasticboy/vim-markdown'
Plug 'elzr/vim-json'
Plug 'pprovost/vim-ps1'
Plug 'pangloss/vim-javascript'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'leafgarland/typescript-vim'
Plug 'OrangeT/vim-csharp'
endif
Plug 'docunext/closetag.vim'
" }}}
" interface {{{
if !exists('g:vscode')
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'ctrlpvim/ctrlp.vim' | Plug 'tacahiroy/ctrlp-funky' | Plug 'sgur/ctrlp-extensions.vim'
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
Plug 'ervandew/supertab'
Plug 'airblade/vim-gitgutter', Cond(executable('git'))
Plug 'tpope/vim-fugitive', { 'on': 'Git' }
Plug 'whiteinge/diffconflicts'
Plug 'justinmk/vim-gtfo'
endif
" }}}
" movement {{{
Plug 'tmhedberg/matchit'
Plug 'tpope/vim-unimpaired'
Plug 'bronson/vim-visual-star-search'
Plug 'justinmk/vim-sneak'
" }}}
" editing {{{
Plug 'tomtom/tcomment_vim', Cond(!exists('g:vscode'))
Plug 'ntpeters/vim-better-whitespace'
Plug 'raimondi/delimitmate'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'
Plug 'terryma/vim-multiple-cursors'
" }}}

" The devicons plugin must be loaded after other plugins it integrates with
Plug 'ryanoasis/vim-devicons', Cond(!exists('g:vscode'))

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
	if !exists('g:airline_symbols')
		let g:airline_symbols = {}
	endif
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
" NERDTree {{{
if !exists('g:vscode')
    map <C-t> :NERDTreeToggle<CR>
endif
" }}}
" sneak {{{
    let g:sneak#use_ic_scs = 1
" }}}
" solarized {{{
	if (has('win32unix'))
		let g:solarized_use16 = 1
	endif
    if !exists('g:vscode')
        colorscheme solarized8
        nnoremap <F5> :<c-u>exe "colors" (g:colors_name =~# "dark"
            \ ? substitute(g:colors_name, 'dark', 'light', '')
            \ : substitute(g:colors_name, 'light', 'dark', '')
            \ )<cr><CR>
    endif
" }}}
" SuperTab {{{
	let g:SuperTabDefaultCompletionType = 'context'
" }}}
" unimpaired {{{
	nmap co yo
" }}}


" vim:foldmethod=marker:foldlevel=0
