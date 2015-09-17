" Author: Brian Golden

"#### environment ####" {{{ 
" Identify platform {{{ 
	silent function! OSX()
		return has('macunix')
	endfunction
	silent function! LINUX()
		return has('unix') && !has('macunix')
			\ && !has('win32unix')
	endfunction
	silent function! WINDOWS()
		return (has('win16') || has('win32') || has('win64'))
	endfunction
"}}}
	set nocompatible
	if !WINDOWS()
		set shell=/bin/sh
	endif

	" Use '.vim' instead of '.vimfiles' on Windows 
	if WINDOWS()
		set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME
	endif
" }}}

"#### general ####" {{{
	set history=700
	syntax on
	set autoread
	let mapleader=","
	let g:mapleader=","
	if has('persistent_undo') " {{{
		silent !mkdir ~/.vim/backups > /dev/null 2>&1
		set undodir=~/.vim/backups
		set undofile
	endif
	" }}}
" }}}

"#### user interface ####" {{{
	set nu
	set backspace=indent,eol,start
	set whichwrap+=<,>,h,l,b,s,h,[,]
	set lazyredraw
	set noerrorbells
	set novisualbell
	if has('cmdline_info')
		set ruler
		set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
	endif

	if has("gui_running")
		set lines=50
		set columns=120
	endif
" }}}

"#### buffers #### {{{
	nmap <leader>m :bn<CR>
	nmap <leader>n :bp<CR>
	nmap <leader>d :bd<CR>
" }}}

"#### formatting ####" {{{
	set splitright    " puts new vsplit windows to the right of the current 
	set splitbelow    " puts new split windows below the current
	set autoindent    " indent at the same level as previous line
" }}}

"#### search ####" {{{
	set ignorecase
	set smartcase
	set incsearch
	set hlsearch
	" Use <C-L> to clear the highlighting of :set hlsearch.
	if maparg('<C-L>', 'n') ==# ''
		nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
	endif
" }}} 

"#### files & colors ####" {{{
	filetype plugin indent on
	autocmd BufNewFile,BufRead *.html setlocal ts=2 sts=2 sw=2
	autocmd BufNewFile,BufRead *.pl set syntax=prolog
	autocmd BufNewFile,BufRead *.xaml set syntax=xml
	autocmd BufNewFile,BufRead *.doskey set syntax=dosbatch
	set ffs=unix,dos,mac
	set t_Co=16
	set background=dark

	if has("gui_running")
		set encoding=utf-8
		set guifont=Consolas\ for\ Powerline\ FixedD:h9 
	endif

	augroup configgroup
		autocmd!
		autocmd FileType python setlocal shiftwidth=4
		autocmd FileType python setlocal tabstop=4
		autocmd FileType python setlocal expandtab
	augroup END

	" set the cursor to the first line of the buffer 
	" when editing a git commit msg
	au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
	autocmd FileType gitcommit setlocal spell textwidth=72
" }}}

"#### motion & navigation ####" {{{
	set mouse=a
	set mousehide
	set virtualedit=onemore
	set scrolloff=3
	
	"http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
	" Restore cursor to file position in previous editing session
	function! ResCur()
		if line("'\"") <= line("$")
			normal! g`"
			return 1
		endif
	endfunction

	augroup resCur
		autocmd!
		autocmd BufWinEnter * call ResCur()
	augroup END
" }}}

"#### completion ####" {{{
	set wildmenu
	set wildmode=list:longest,full
	set wildignore=*.o,*~,*.pyc
	set wildignore+=*vim/backups
	set wildignore+=*.png,*.jpg,*.gif
	set wildignore+=*/tmp/*,*.so
	set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe,*.dll
	set omnifunc=syntaxcomplete#Complete
	" close preview after selection is made
	autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
	autocmd InsertLeave * if pumvisible() == 0|pclose|endif
" }}}

"#### tabs & indentation ####" {{{
	set smarttab
	set ai        " auto indent
	set si        " smart indent
	set nowrap
	nmap <leader>r :set wrap!<CR>
" }}}

" #### folding ####" {{{
	set foldenable
	set foldlevelstart=10      " open most folds by default
	set foldnestmax=10
	set foldmethod=indent      " fold based on indent level
	set modelines=1
	" space opens/closes folds
	nnoremap <space> za
" }}}

"#### backups ####" {{{
	set backupdir=~/.vimtmp,~/.tmp,~/tmp,/var/tmp,/tmp
	set directory=~/.vimtmp,~/.tmp,~/tmp,/var/tmp,/tmp,$TEMP
 " }}}

"#### key (re)mappings ####" {{{
	" fast saving
	nmap <leader>w :w<cr>
	nmap <silent> <leader>ev :e $HOME/.vim/base.vimrc<CR>
	nmap <silent> <leader>sv :so $HOME/.vim/base.vimrc<CR>

	if has("user_commands")
		command! -bang -nargs=* -complete=file W w<bang> <args>
		command! -bang -nargs=* -complete=file Wq wq<bang> <args>
		command! -bang -nargs=* -complete=file WQ wq<bang> <args>
		command! -bang Q q<bang>
	endif

	" For when you forget to sudo
	cmap w!! w !sudo tee % > /dev/null

	" Display all lines with keyword under the cursor, 
	" ask which to jump to
	nmap <leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
"}}}

"#### functions ####" {{{
	" Highlight characters past 80 characters
	function ToggleColorColumn()
		if &colorcolumn == ""
			execute "set colorcolumn=" . join(range(81, 335), ',')
		else
			set colorcolumn=
		endif
	endfunction
	nmap <leader>k :call ToggleColorColumn()<CR>
"}}}

" vim:foldmethod=marker:foldlevel=0
