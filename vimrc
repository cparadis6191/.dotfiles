" .vimrc - Save this file as .vimrc in your home directory. (e.g. /home/user/.vimrc)
" Author: Chad Paradis


" -- important --
set nocompatible    " Use the full power of Vim

" -- moving around, searching and patterns --
set incsearch     " Jumps to the first match while typing
set ignorecase    " When doing a search, ignore the case of letters
set smartcase     " Override the ignorecase option if the search pattern contains upper case letters

" -- tags --

" -- displaying text --
set scrolloff=5    " Keep the cursor at least five lines from the bottom or top
set linebreak      " Wrap lines at a convenient place

if has('patch-7.4.338')
	set breakindent
	let &showbreak='  > '
endif

set number

" -- syntax, highlighting and spelling --
filetype plugin indent on    " Turns on filetype plugins and indenting
syntax enable                " Turns on syntax highlighting
set hlsearch                 " Highlight search results
set cursorcolumn             " Highlight the current column

" -- multiple windows --
set laststatus=2    " Always show the statusline
set hidden          " Hide buffers instead of closing them

" -- multiple tab pages --
set showtabline=2    " Always show the tabline
set tabpagemax=99    " Increase the max number of tabs opened at once

" -- terminal --
" -- using the mouse --
" -- printing --

" -- messages and info --
set showcmd    " Show incomplete commands at the bottom
set ruler      " Information about cursor placement

" -- selecting text --
set clipboard=unnamed    " Default to the system clipboard

" -- editing text --
set undolevels=999                " Increase history size for undoing edits
set backspace=indent,eol,start    " Allow backspace in insert mode

" -- tabs and indenting --
set tabstop=4       " Tab size is 4 spaces
set shiftwidth=4    " Sets < and > shifts to be 4 characters
set shiftround      " When using < and > rounds to the nearest multiple of shiftwidth
set noexpandtab     " Strictly use tabs when tab is pressed (this is the default)
set autoindent      " Copy indent from current line when starting a new line

" -- folding --
set foldlevelstart=99    " Buffers start with all folds open
set foldmethod=syntax

" -- diff mode --

" -- mapping --
" Comments CANNOT be on the same line as a map
" Navigate wrapped lines in a sane way
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

nnoremap 0 g0
nnoremap $ g$
nnoremap g0 0
nnoremap g$ $

" Make Y behave more like C and D
nnoremap Y y$

" Use <C-H> and <C-L> to cycle through tabs
nnoremap <C-L> gt
nnoremap <C-H> gT

" Open file under cursor in new tab
nnoremap gf <C-W>gf
" Open file under cursor in new tab and jump to line number
nnoremap gF <C-W>gF

" Shifting in visual mode now reselects the block
vnoremap > >gv
vnoremap < <gv

" -- reading and writing files --
" -- the swap file --

" -- command line editing --
set history=999              " Increase history size for commands and search patterns
set wildmode=longest:full    " Make autocomplete more bash-like
set wildmenu                 " List external files instead of just autocompleting
set wildoptions=tagfile      " List autocomplete for command line options

" -- executing external commands --
" -- running make and jumping to errors --
" -- language specific --
" -- multi-byte characters --
" -- various --
set exrc
set secure

" -- plugins --
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !mkdir -p ~/.vim/autoload
	silent !curl -fLo ~/.vim/autoload/plug.vim
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin()
	Plug 'https://github.com/kien/rainbow_parentheses.vim.git'
	Plug 'https://github.com/scrooloose/syntastic.git', { 'on': ['SyntasticCheck', 'SyntasticInfo', 'SyntasticReset', 'SyntasticSetLoclist', 'SyntasticToggleMode'] }
	Plug 'https://github.com/tpope/vim-fugitive.git'
call plug#end()

let g:rbpt_max=16
let g:rbpt_loadcmd_toggle=0

autocmd VimEnter * RainbowParenthesesToggle
autocmd Syntax   * RainbowParenthesesLoadRound     " ()
autocmd Syntax   * RainbowParenthesesLoadSquare    " []
autocmd Syntax   * RainbowParenthesesLoadBraces    " {}

let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=1
let g:syntastic_check_on_wq=0
