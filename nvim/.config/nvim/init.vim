" -- plugins --
if empty(glob('$HOME/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo $HOME/.config/nvim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
augroup PlugInstallGroup
	autocmd!
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
augroup END
endif
if empty(glob('$HOME/.config/nvim/autoload/plug.vim'))
	silent !mkdir -p $HOME/.config/nvim/autoload
	silent !wget -qO $HOME/.config/nvim/autoload/plug.vim
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
augroup PlugInstallGroup
	autocmd!
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
augroup END
endif

call plug#begin()
	" vim-neovim-defaults
	if !has('nvim')
		Plug 'noahfrederick/vim-neovim-defaults'
	endif

	" Text manipulation
	Plug 'junegunn/vim-easy-align'
	Plug 'justinmk/vim-sneak'
	Plug 'mbbill/undotree'
	Plug 'tpope/vim-commentary'
	Plug 'tpope/vim-repeat'
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-unimpaired'

	" Display
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

	" Programming
	Plug 'mhinz/vim-signify'
	Plug 'neomake/neomake'
	Plug 'tpope/vim-fugitive'
call plug#end()

" -- important --
if !has('nvim')
	runtime! plugin/neovim_defaults.vim
endif

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
set nojoinspaces    " Joining lines at punctuation will not insert an extra space

" -- tabs and indenting --
set tabstop=4
set shiftwidth=0    " Sets < and > shifts to be the value of tabstop
set shiftround      " Rounds to the nearest multiple of shiftwidth when using < and >
set copyindent      " Copy whitespace for indenting from previous line

" -- folding --
" -- diff mode --

" -- mapping --
" Comments CANNOT be on the same line as a map
let mapleader="\<Space>"

" Make Y behave more like C and D
nnoremap Y y$

" Shifting in visual mode now reselects the block
xnoremap > >gv
xnoremap < <gv

" Use Q for executing the macro in the q register
nnoremap Q @q

" Search for visual selecions
xnoremap * :<C-u>call <SID>VisualSearch()<CR>/<CR>
xnoremap # :<C-u>call <SID>VisualSearch()<CR>?<CR>

function! s:VisualSearch()
	let temp=@@
	normal! gvy
	let @/='\V' . substitute(escape(@@, '\'), '\_s\+', '\\_s\\+', 'g')
	call histadd('/', substitute(@/, '[?/]', '\="\\%d" . char2nr(submatch(0))', 'g'))
	let @@=temp
endfunction

if exists(':terminal')
	tnoremap <Esc><Esc> <C-\><C-n>
	nmap <Leader>t :below split <Bar> terminal<CR>
endif

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
set wildmode=longest:full    " Make autocomplete more like bash

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
set exrc        " Use project specific .exrc files
set secure
set gdefault    " Substitute all matches on a line

" -- plugin settings --

" netrw
let g:netrw_liststyle=3

" easy-align
nmap <Leader>a <Plug>(EasyAlign)
xmap <Leader>a <Plug>(EasyAlign)

" Sneak
let g:sneak#label=1

map <Leader>s <Plug>Sneak_s
map <Leader>S <Plug>Sneak_S

" Replace f with Sneak
map f <Plug>Sneak_f
map F <Plug>Sneak_F

" Replace t with Sneak
map t <Plug>Sneak_t
map T <Plug>Sneak_T

" undotree
nnoremap <Leader>u :UndotreeToggle<CR>

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
nnoremap <Leader>l :Unite -start-insert locate<CR>
nnoremap <Leader>y :Unite history/yank<CR>

" SnipMate
imap <C-l> <C-r><Tab>

" Neomake
let g:neomake_open_list=2
nnoremap <Leader>m :Neomake!<CR>

" signify
highlight SignifySignDelete cterm=bold ctermbg=1
highlight SignifySignAdd    cterm=bold ctermbg=2
highlight SignifySignChange cterm=bold ctermbg=3

" fugitive
nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>gd :Gvdiff<CR>
nnoremap <Leader>ge :Gedit<CR>
nnoremap <Leader>gg :Ggrep<Space>
nnoremap <Leader>gl :Glog<CR>
nnoremap <Leader>gs :Gstatus<CR>

" Load local init.vim
if !empty(glob('$HOME/.config/nvim/local.init.vim'))
	source $HOME/.config/nvim/local.init.vim
endif
