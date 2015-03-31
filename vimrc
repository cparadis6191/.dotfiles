" .vimrc - Use link.sh to create a symbolic link in $HOME
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

if exists('+breakindent')
	set breakindent
	let &showbreak='  > '
endif

set list    " Used to position the cursor at the left edge of a tab
let &listchars='tab:  '

set number

" -- syntax, highlighting and spelling --
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
set copyindent      " Copy whitespace for indenting from previous line

" -- folding --
set foldlevelstart=99    " Buffers start with all folds open
set foldmethod=syntax

" -- diff mode --

" -- mapping --
" Comments CANNOT be on the same line as a map
" Navigate wrapped lines in a sane way
" noremap maps normal mode, visual mode, and operater-pending mode
" Use sunmap so select mode is not trashed
noremap k gk
sunmap  k
noremap gk k
sunmap  gk

noremap j gj
sunmap  j
noremap gj j
sunmap  gj

noremap 0 g0
sunmap  0
noremap g0 0
sunmap  g0

noremap ^ g^
sunmap  ^
noremap g^ ^
sunmap  g^

noremap $ g$
sunmap  $
noremap g$ $
sunmap  g$

" Make Y behave more like C and D
nnoremap Y y$

" Shifting in visual mode now reselects the block
xnoremap > >gv
xnoremap < <gv

" Use <C-H> and <C-L> to cycle through tabs
nnoremap <C-L> gt
nnoremap <C-H> gT

" Open file under cursor in new tab
nnoremap gf <C-W>gf
nnoremap <C-W>gf gf

" Open file under cursor in new tab and jump to line number
nnoremap <C-W>gF gF
nnoremap gF <C-W>gF

" Navigate buffers similar to tabs
nnoremap gb :bnext<CR>
nnoremap gB :bprev<CR>
nnoremap <C-K> :bnext<CR>
nnoremap <C-J> :bprev<CR>

" -- reading and writing files --
set backup
if empty(glob('$HOME/.vim/backup'))
	silent !mkdir -p $HOME/.vim/backup
endif
set backupdir^=$HOME/.vim/backup//

" -- the swap file --
if empty(glob('$HOME/.vim/swap'))
	silent !mkdir -p $HOME/.vim/swap
endif
set directory^=$HOME/.vim/swap//

" -- command line editing --
set history=999              " Increase history size for commands and search patterns
set wildmode=longest:full    " Make autocomplete more bash-like
set wildmenu                 " List external files instead of just autocompleting
set wildoptions=tagfile      " List autocomplete for command line options

set undofile
if empty(glob('$HOME/.vim/undo'))
	silent !mkdir -p $HOME/.vim/undo
endif
set undodir^=$HOME/.vim/undo//

" -- executing external commands --
" -- running make and jumping to errors --
" -- language specific --
" -- multi-byte characters --

" -- various --
set exrc                       " Use project specific .exrc files
set secure
set sessionoptions-=options    " Do not save options in a session

" -- plugins --
if empty(glob('$HOME/.vim/autoload/plug.vim'))
	silent !mkdir -p $HOME/.vim/autoload
	silent !curl -fLo $HOME/.vim/autoload/plug.vim
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall
endif

" plug#begin() automatically calls
" filetype plugin indent on
call plug#begin()
	Plug 'https://github.com/kien/rainbow_parentheses.vim.git'
	Plug 'https://github.com/scrooloose/syntastic.git', { 'on': ['SyntasticCheck', 'SyntasticInfo', 'SyntasticReset', 'SyntasticSetLoclist', 'SyntasticToggleMode'] }
	Plug 'https://github.com/tpope/vim-fugitive.git'
	Plug 'https://github.com/vimwiki/vimwiki'
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
