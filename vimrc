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

set lazyredraw
set number

" -- syntax, highlighting and spelling --
syntax enable                " Turns on syntax highlighting
set hlsearch                 " Highlight search results
set cursorcolumn             " Highlight the current column

" -- multiple windows --
set laststatus=2    " Always show the statusline
let &statusline='%<%f %y%h%m%r %{(exists("g:loaded_fugitive")) ? fugitive#statusline() : ""} %#warningmsg#%{(exists("g:loaded_syntastic_plugin")) ? SyntasticStatuslineFlag() : ""}%*%=%-2b %-4(0x%B%) %-15(%l,%c%V%) %P'
set hidden          " Hide buffers instead of closing them

" -- multiple tab pages --
set showtabline=2    " Always show the tabline
set tabpagemax=99    " Increase the max number of tabs opened at once

" -- terminal --
set title

" -- using the mouse --
" -- printing --

" -- messages and info --
set showcmd    " Show incomplete commands at the bottom

" -- selecting text --
set clipboard=unnamed    " Default to the system clipboard

" -- editing text --
set undolevels=999                " Increase history size for undoing edits
set undoreload=9999
set backspace=indent,eol,start    " Allow backspace in insert mode
set formatoptions+=j              " Joining comments will remove the comment leader of the lower line
set nojoinspaces                  " Joining lines at a '.' will not insert an extra space

" -- tabs and indenting --
set tabstop=4       " Tab size is 4 spaces
set shiftwidth=0    " Sets < and > shifts to be the value of tabstop
set shiftround      " When using < and > rounds to the nearest multiple of shiftwidth
set autoindent      " Copy indent from current line when starting a new line
set copyindent      " Copy whitespace for indenting from previous line

" -- folding --
" -- diff mode --

" -- mapping --
" Comments CANNOT be on the same line as a map
" Navigate wrapped lines in a sane way
" Only map normal mode and visual mode
" Navigate linewise in normal mode and with a count
" Navigate wrapped linewise in visual mode and blockwise-visual mode and without a count
" mode() returns the current editing mode
" !=# is a case sensitive comparison
nnoremap <expr> j   (v:count == 0)                      ? 'gj' : 'j'
xnoremap <expr> j  ((v:count == 0) && (mode() !=# 'V')) ? 'gj' : 'j'
nnoremap <expr> gj  (v:count == 0)                      ? 'j'  : 'gj'
xnoremap <expr> gj ((v:count == 0) && (mode() !=# 'V')) ? 'j'  : 'gj'

nnoremap <expr> k   (v:count == 0)                      ? 'gk' : 'k'
xnoremap <expr> k  ((v:count == 0) && (mode() !=# 'V')) ? 'gk' : 'k'
nnoremap <expr> gk  (v:count == 0)                      ? 'k'  : 'gk'
xnoremap <expr> gk ((v:count == 0) && (mode() !=# 'V')) ? 'k'  : 'gk'

" Only remap normal mode and visual mode
nnoremap 0  g0
xnoremap 0  g0
nnoremap g0 0
xnoremap g0 0

nnoremap ^  g^
xnoremap ^  g^
nnoremap g^ ^
xnoremap g^ ^

nnoremap $  g$
xnoremap $  g$
nnoremap g$ $
xnoremap g$ $

" Make Y behave more like C and D
nnoremap Y y$

" Shifting in visual mode now reselects the block
xnoremap > >gv
xnoremap < <gv

" Navigate splits more easily
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l

" Move splits around more easily
nnoremap <C-LEFT>  <C-W>H
nnoremap <C-DOWN>  <C-W>J
nnoremap <C-UP>    <C-W>K
nnoremap <C-RIGHT> <C-W>L

" Open file under cursor in new tab instead of a new buffer
nnoremap      gf <C-W>gf
xnoremap      gf <C-W>gf
nnoremap <C-W>gf      gf
xnoremap <C-W>gf      gf
nnoremap      gF <C-W>gF
xnoremap      gF <C-W>gF
nnoremap <C-W>gF      gF
xnoremap <C-W>gF      gF

" Navigate buffers similar to tabs
nnoremap gB :bprev<CR>
nnoremap gb :bnext<CR>

" Use Q for executing last macro
nnoremap Q @q

" Search for visual selecions
xnoremap * "zy/<C-R>z<CR>
xnoremap # "zy?<C-R>z<CR>

" -- reading and writing files --
set backup
if empty(glob('$HOME/.vim/backup'))
	silent !mkdir -p $HOME/.vim/backup
endif
set backupdir^=$HOME/.vim/backup//

set autowrite    " Save on commands like :suspend or :make

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
set exrc        " Use project specific .exrc files
set secure
set gdefault    " Use the 'g' flag for ":substitute"

" -- plugins --
if empty(glob('$HOME/.vim/autoload/plug.vim'))
	silent !curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall
endif
if empty(glob('$HOME/.vim/autoload/plug.vim'))
	silent !mkdir -p $HOME/.vim/autoload
	silent !wget -qO $HOME/.vim/autoload/plug.vim
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall
endif

" plug#begin() automatically calls
" filetype plugin indent on
call plug#begin()
	" SnipMate
	Plug 'https://github.com/tomtom/tlib_vim'
	Plug 'https://github.com/MarcWeber/vim-addon-mw-utils'
	Plug 'https://github.com/garbas/vim-snipmate'
	Plug 'https://github.com/honza/vim-snippets'

	" Text manipulation
	Plug 'https://github.com/Raimondi/delimitMate'
	Plug 'https://github.com/godlygeek/tabular'
	Plug 'https://github.com/kien/rainbow_parentheses.vim'
	Plug 'https://github.com/tpope/vim-commentary'
	Plug 'https://github.com/tpope/vim-repeat'
	Plug 'https://github.com/tpope/vim-surround'

	Plug 'https://github.com/scrooloose/syntastic', { 'for': ['c', 'cpp', 'h'] }
	Plug 'https://github.com/airblade/vim-gitgutter'
	Plug 'https://github.com/tpope/vim-fugitive'

	" Navigation
	Plug 'https://github.com/Shougo/unite.vim'
	Plug 'https://github.com/vim-scripts/a.vim'

	Plug 'https://github.com/vimwiki/vimwiki'
call plug#end()

" SnipMate
inoremap <C-L> <Esc>:SnipMateOpenSnippetFiles<CR>

" Rainbow Parentheses
let g:rbpt_max=16
let g:rbpt_loadcmd_toggle=0
autocmd VimEnter * RainbowParenthesesToggle
autocmd Syntax   * RainbowParenthesesLoadRound     " ()
autocmd Syntax   * RainbowParenthesesLoadSquare    " []
autocmd Syntax   * RainbowParenthesesLoadBraces    " {}

" a.vim
nnoremap gA :AT<CR>

" Syntastic
let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=1
let g:syntastic_check_on_wq=0

" Git Gutter
let g:gitgutter_sign_column_always=1
let g:gitgutter_realtime=1
let g:gitgutter_eager=1

" Unite
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#custom#default_action('file', 'tabswitch')
call unite#custom#default_action('buffer', 'tabswitch')
nnoremap <C-P> :Unite -start-insert file_rec<CR>
nnoremap <C-B> :Unite -start-insert buffer<CR>
nnoremap <C-G> :Unite vimgrep<CR><CR>

let g:vimwiki_list=[{'path': '$HOME/Dropbox/Private/vimwiki'}]
