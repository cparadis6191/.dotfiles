" plugins
if empty(glob('$HOME/.vim/autoload/plug.vim'))
	silent !curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
augroup PlugInstallGroup
	autocmd!
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
augroup END
endif
if empty(glob('$HOME/.vim/autoload/plug.vim'))
	silent !mkdir -p $HOME/.vim/autoload
	silent !wget -qO $HOME/.vim/autoload/plug.vim
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
augroup PlugInstallGroup
	autocmd!
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
augroup END
endif

" plug#begin() automatically calls
" filetype plugin indent on
call plug#begin()
	" vim-neovim-defaults
	Plug 'noahfrederick/vim-neovim-defaults'

	" text manipulation
	Plug 'junegunn/vim-easy-align'
	Plug 'justinmk/vim-sneak'
	Plug 'mbbill/undotree'
	Plug 'tpope/vim-commentary'
	Plug 'tpope/vim-repeat'
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-unimpaired'

	" display
	Plug 'bronson/vim-trailing-whitespace'
	Plug 'junegunn/rainbow_parentheses.vim'

	" Unite
	Plug 'Shougo/unite.vim'
	Plug 'Shougo/neoyank.vim'
	Plug 'ujihisa/unite-locate'

	" SnipMate
	Plug 'tomtom/tlib_vim'
	Plug 'MarcWeber/vim-addon-mw-utils'
	Plug 'garbas/vim-snipmate'
	Plug 'honza/vim-snippets'

	" programming
	Plug 'airblade/vim-gitgutter'
	Plug 'neomake/neomake'
	Plug 'tpope/vim-fugitive'

	" tags
	Plug 'majutsushi/tagbar'
call plug#end()

" -- important --
runtime! plugin/neovim_defaults.vim

" -- moving around, searching and patterns --
set ignorecase
set smartcase

" -- tags --

" -- displaying text --
set scrolloff=5
set linebreak

if exists('+breakindent')
	set breakindent
	let &showbreak='  > '
endif

set lazyredraw
set number

" -- syntax, highlighting and spelling --
syntax enable

" -- multiple windows --
let &statusline=' %<%f [%{(&fileencoding ? &fileencoding : &encoding)}] %y%m%r %{(exists("g:loaded_fugitive")) ? fugitive#statusline() : ""} %= %-3b %-4(0x%B%) %-12(%5(%l,%)%c%V%) %P '
set hidden

" -- multiple tab pages --

" -- terminal --
set title

" -- using the mouse --
" -- printing --

" -- messages and info --
set showcmd

" -- selecting text --
set clipboard^=unnamedplus

" -- editing text --
set nojoinspaces    " joining lines at punctuation will not insert an extra space

" -- tabs and indenting --
set tabstop=4
set shiftwidth=0    " sets < and > shifts to be the value of tabstop
set shiftround      " rounds to the nearest multiple of shiftwidth when using < and >
set copyindent      " copy whitespace for indenting from previous line

" -- folding --
" -- diff mode --

" -- mapping --
" comments CANNOT be on the same line as a map
let mapleader="\<Space>"

" make Y behave more like C and D
nnoremap Y y$

" shifting in visual mode now reselects the block
xnoremap > >gv
xnoremap < <gv

" use Q for executing the macro in the q register
nnoremap Q @q

" search for visual selecions
xnoremap * :<C-u>call <SID>VisualSearch()<CR>/<CR>
xnoremap # :<C-u>call <SID>VisualSearch()<CR>?<CR>

function! s:VisualSearch()
	let temp=@@
	normal! gvy
	let @/='\V' . substitute(escape(@@, '\'), '\_s\+', '\\_s\\+', 'g')
	call histadd('/', substitute(@/, '[?/]', '\="\\%d" . char2nr(submatch(0))', 'g'))
	let @@=temp
endfunction

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
set wildmode=longest:full    " make autocomplete more like bash

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
set exrc        " use project specific .exrc files
set secure
set gdefault    " substitute all matches on a line

" -- plugin settings --

" netrw
let g:netrw_liststyle=3

" easy-align
nmap <Leader>a <Plug>(EasyAlign)
xmap <Leader>a <Plug>(EasyAlign)

" Sneak
let g:sneak#streak=1

map <Leader>s <Plug>Sneak_s
map <Leader>S <Plug>Sneak_S

" replace f with Sneak
map f <Plug>Sneak_f
map F <Plug>Sneak_F

" replace t with Sneak
map t <Plug>Sneak_t
map T <Plug>Sneak_T

" undotree
nnoremap <Leader>ut :UndotreeToggle<CR>

" Rainbow Parentheses
let g:rainbow#blacklist=[0, 255]
let g:rainbow#pairs=[['(', ')'], ['[', ']'], ['{', '}']]
augroup RainbowParenthesesGroup
	autocmd!
	autocmd VimEnter * RainbowParentheses
augroup END

" Unite
let g:unite_enable_auto_select=0
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
nnoremap <Leader>b :Unite buffer<CR>
nnoremap <Leader>f :Unite -start-insert file_rec/neovim<CR>
nnoremap <Leader>g :Unite vimgrep<CR><CR>
nnoremap <Leader>l :Unite -start-insert locate<CR>
nnoremap <Leader>y :Unite history/yank<CR>

" SnipMate
imap <C-l> <C-r><Tab>

" Neomake
let g:neomake_open_list=2

" tagbar
nnoremap <Leader>tb :TagbarToggle<CR>

" load local vimrc
if !empty(glob('$HOME/.local.vimrc'))
	source $HOME/.local.vimrc
endif
