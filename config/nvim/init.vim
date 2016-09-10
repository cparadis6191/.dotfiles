" -- important --
if !empty(glob('$HOME/.config/nvim/local.init.vim'))
	source $HOME/.config/nvim/local.init.vim
endif

" -- moving around, searching and patterns --
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

set lazyredraw
set number

" -- syntax, highlighting and spelling --
syntax enable                " Turns on syntax highlighting

" -- multiple windows --
let &statusline=' %<%f %y%h%m%r%{(exists("g:loaded_fugitive")) ? fugitive#statusline() : ""} %*%=%-2b %-4(0x%B%) %-15(%l,%c%V%) %P '
set hidden          " Hide buffers instead of closing them

" -- multiple tab pages --

" -- terminal --
set title

" -- using the mouse --
" -- printing --

" -- messages and info --
set showcmd    " Show incomplete commands at the bottom

" -- selecting text --
set clipboard^=unnamedplus    " Default to the system clipboard

" -- editing text --
set nojoinspaces                  " Joining lines at punctuation will not insert an extra space

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
" Make Y behave more like C and D
let mapleader="\<Space>"

nnoremap Y y$

" Shifting in visual mode now reselects the block
xnoremap > >gv
xnoremap < <gv

" Navigate buffers similar to tabs
nnoremap gB :bprev<CR>
nnoremap gb :bnext<CR>

" Switch to last used buffer
nnoremap gl <C-^>

" Use Q for executing the macro in the q register
nnoremap Q @q

" Search for visual selecions
xnoremap * "zy/\V<C-R>z<CR>
xnoremap # "zy?\V<C-R>z<CR>

" -- reading and writing files --
set backup
if empty(glob('$HOME/.config/nvim/backup'))
	silent !mkdir -p $HOME/.config/nvim/backup
endif
set backupdir^=$HOME/.config/nvim/backup//

" -- the swap file --
if empty(glob('$HOME/.config/nvim/swap'))
	silent !mkdir -p $HOME/.config/nvim/swap
endif
set directory^=$HOME/.config/nvim/swap//

" -- command line editing --
set wildmode=longest:full    " Make autocomplete more bash-like

set undofile
if empty(glob('$HOME/.config/nvim/undo'))
	silent !mkdir -p $HOME/.config/nvim/undo
endif
set undodir^=$HOME/.config/nvim/undo//

" -- executing external commands --
" -- running make and jumping to errors --
" -- language specific --
" -- multi-byte characters --

" -- various --
set exrc                       " Use project specific .exrc files
set secure
set gdefault                   " Use the 'g' flag for ':substitute'

" -- plugins --
if empty(glob('$HOME/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo $HOME/.config/nvim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall
endif
if empty(glob('$HOME/.config/nvim/autoload/plug.vim'))
	silent !mkdir -p $HOME/.config/nvim/autoload
	silent !wget -qO $HOME/.config/nvim/autoload/plug.vim
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall
endif

" plug#begin() automatically calls
" filetype plugin indent on
call plug#begin()
	" Text manipulation
	Plug 'https://github.com/junegunn/vim-easy-align'
	Plug 'https://github.com/mbbill/undotree'
	Plug 'https://github.com/tpope/vim-commentary'
	Plug 'https://github.com/tpope/vim-repeat'
	Plug 'https://github.com/tpope/vim-surround'

	" Display
	Plug 'https://github.com/bronson/vim-trailing-whitespace'
	Plug 'https://github.com/junegunn/rainbow_parentheses.vim'

	" Unite
	Plug 'https://github.com/Shougo/unite.vim'
	Plug 'https://github.com/Shougo/neomru.vim'
	Plug 'https://github.com/Shougo/neoyank.vim'
	Plug 'https://github.com/ujihisa/unite-locate'

	" SnipMate
	Plug 'https://github.com/tomtom/tlib_vim'
	Plug 'https://github.com/MarcWeber/vim-addon-mw-utils'
	Plug 'https://github.com/garbas/vim-snipmate'
	Plug 'https://github.com/honza/vim-snippets'

	" Programming
	Plug 'https://github.com/airblade/vim-gitgutter'
	Plug 'https://github.com/neomake/neomake'
	Plug 'https://github.com/tpope/vim-fugitive'

	" tags
	Plug 'https://github.com/fntlnz/atags.vim'
	Plug 'https://github.com/majutsushi/tagbar'
call plug#end()

" netrw
let g:netrw_liststyle=3

" easy-align
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" undotree
nnoremap <Leader>ut :UndotreeToggle<CR>

" Rainbow Parentheses
let g:rainbow#blacklist=[0, 255]
let g:rainbow#pairs=[['(', ')'], ['[', ']'], ['{', '}']]
autocmd VimEnter * RainbowParentheses

" Unite
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
nnoremap <Leader>ub :Unite buffer<CR>
nnoremap <Leader>uf :Unite -start-insert file_rec/neovim<CR>
nnoremap <Leader>ug :Unite vimgrep<CR><CR>
nnoremap <Leader>ul :Unite -start-insert locate<CR>
nnoremap <Leader>ur :Unite neomru/file<CR>
nnoremap <Leader>uy :Unite history/yank<CR>

" SnipMate
imap <C-L> <C-R><Tab>

" Git Gutter
let g:gitgutter_sign_column_always=1

" Neomake
let g:neomake_open_list=2

" atags
nnoremap <Leader>tu :call atags#generate()<CR>

" tagbar
nnoremap <Leader>tb :TagbarToggle<CR>
