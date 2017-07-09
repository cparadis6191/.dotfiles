" -- important --
let $VIMFILES=split(&runtimepath, ',')[0]

" -- plugins --
if empty(glob('$VIMFILES/autoload/plug.vim'))
	silent !curl -fLo $VIMFILES/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
augroup PlugInstallGroup
	autocmd!
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
augroup END
endif
if empty(glob('$VIMFILES/autoload/plug.vim'))
	silent !mkdir -p $VIMFILES/autoload
	silent !wget -qO $VIMFILES/autoload/plug.vim
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

	" Display
	Plug 'bronson/vim-trailing-whitespace'
	Plug 'junegunn/rainbow_parentheses.vim'
	Plug 'justinmk/vim-dirvish'

	" Editing
	Plug 'junegunn/vim-easy-align'
	Plug 'mbbill/undotree'
	Plug 'tpope/vim-commentary'
	Plug 'tpope/vim-repeat'
	Plug 'tpope/vim-surround'

	" Git
	Plug 'mhinz/vim-signify'
	Plug 'tpope/vim-fugitive'

	" Movement
	Plug 'justinmk/vim-sneak'
	Plug 'tpope/vim-unimpaired'

	" Neomake
	Plug 'neomake/neomake'

	" SnipMate
	Plug 'tomtom/tlib_vim'
	Plug 'MarcWeber/vim-addon-mw-utils'
	Plug 'garbas/vim-snipmate'
	Plug 'honza/vim-snippets'

	" Unite
	Plug 'Shougo/unite.vim'
	Plug 'Shougo/neoyank.vim'
	Plug 'ujihisa/unite-locate'
call plug#end()

if !has('nvim')
	runtime! plugin/neovim_defaults.vim
endif

" -- plugin settings --
" mapleader must be set BEFORE <Leader> maps are specified
let mapleader="\<Space>"

" Display
" Rainbow Parentheses
let g:rainbow#blacklist=[0, 255]
let g:rainbow#pairs=[['(', ')'], ['[', ']'], ['{', '}']]
augroup RainbowParenthesesGroup
	autocmd!
	autocmd VimEnter * RainbowParentheses
augroup END

" dirvish
nmap <Leader>e :Dirvish<CR>
augroup DirvishGroup
	autocmd!
	autocmd VimEnter * unmap -
augroup END

" Editing
" easy-align
nmap <Leader>a <Plug>(EasyAlign)
xmap <Leader>a <Plug>(EasyAlign)

" undotree
nnoremap <Leader>u :UndotreeToggle<CR>

" Git
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

" Movement
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

" Neomake
let g:neomake_open_list=2
nnoremap <Leader>m :Neomake!<CR>

" SnipMate
imap <C-l> <Plug>snipMateShow

" Unite
let g:unite_enable_auto_select=0
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
nnoremap <Leader>b :Unite buffer<CR>
if !has('nvim')
	nnoremap <Leader>f :Unite -start-insert file_rec<CR>
else
	nnoremap <Leader>f :Unite -start-insert file_rec/neovim<CR>
endif
nnoremap <Leader>l :Unite -start-insert locate<CR>
nnoremap <Leader>y :Unite history/yank<CR>

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
" Make Y behave more like C and D
nnoremap Y y$

" Use Q for executing the macro in the q register
nnoremap Q @q
xnoremap Q :normal! @q<CR>

" Search for visual selecions
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<CR>

function! s:VSetSearch()
	let temp=@@
	normal! gvy
	let @/='\V' . substitute(escape(@@, '\'), '\_s\+', '\\_s\\+', 'g')
	call histadd('/', substitute(@/, '[?/]', '\="\\%d" . char2nr(submatch(0))', 'g'))
	let @@=temp
endfunction

if exists(':terminal')
	tnoremap <Esc><Esc> <C-\><C-n>
	nnoremap <Leader>t :below split <Bar> terminal<CR>
endif

" -- reading and writing files --
set backup
if empty(glob('$VIMFILES/backup'))
	silent !mkdir -p $VIMFILES/backup
endif
set backupdir^=$VIMFILES/backup//

" -- the swap file --
if empty(glob('$VIMFILES/swap'))
	silent !mkdir -p $VIMFILES/swap
endif
set directory^=$VIMFILES/swap//

" -- command line editing --
set wildmode=longest:full    " Make autocomplete more like bash

set undofile
if empty(glob('$VIMFILES/undo'))
	silent !mkdir -p $VIMFILES/undo
endif
set undodir^=$VIMFILES/undo//

" -- executing external commands --
" -- running make and jumping to errors --
" -- language specific --
" -- multi-byte characters --

" -- various --
set exrc        " Use project specific .exrc files
set secure
set gdefault    " Substitute all matches on a line

" Load local config
if !has('nvim')
	if !empty(glob('$HOME/.vimrc.local'))
		source $HOME/.vimrc.local
	endif
else
	if !empty(glob('$VIMFILES/.local.init.vim'))
		source $VIMFILES/.local.init.vim
	endif
endif
