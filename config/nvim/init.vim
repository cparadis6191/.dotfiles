" -- important --

" -- moving around, searching and patterns --
set ignorecase    " when doing a search, ignore the case of letters
set smartcase     " override the ignorecase option if the search pattern contains upper case letters

" -- tags --

" -- displaying text --
set scrolloff=5    " keep the cursor at least five lines from the bottom or top
set linebreak      " wrap lines at a convenient place

if exists('+breakindent')
	set breakindent
	let &showbreak='  > '
endif

set lazyredraw
set number

" -- syntax, highlighting and spelling --
syntax enable    " turns on syntax highlighting

" -- multiple windows --
let &statusline=' %<%f [%{(&fileencoding ? &fileencoding : &encoding)}] %y%m%r %{(exists("g:loaded_fugitive")) ? fugitive#statusline() : ""} %= %-3b %-4(0x%B%) %-12(%5(%l,%)%c%V%) %P '
set hidden    " hide buffers instead of closing them

" -- multiple tab pages --

" -- terminal --
set title

" -- using the mouse --
" -- printing --

" -- messages and info --
set showcmd    " show incomplete commands at the bottom

" -- selecting text --
set clipboard^=unnamedplus    " default to the system clipboard

" -- editing text --
set nojoinspaces    " joining lines at punctuation will not insert an extra space

" -- tabs and indenting --
set tabstop=4       " tab size is 4 spaces
set shiftwidth=0    " sets < and > shifts to be the value of tabstop
set shiftround      " rounds to the nearest multiple of shiftwidth when using < and >
set copyindent      " copy whitespace for indenting from previous line

" -- folding --
" -- diff mode --

" -- mapping --
" comments CANNOT be on the same line as a map
" make Y behave more like C and D
let mapleader="\<Space>"

nnoremap Y y$

" shifting in visual mode now reselects the block
xnoremap > >gv
xnoremap < <gv

" use Q for executing the macro in the q register
nnoremap Q @q

" search for visual selecions
function! s:VSetSearch()
	let temp=@@
	norm! gvy
	let @/='\V' . substitute(escape(@@, '\'), '\_s\+', '\\_s\\+', 'g')
	call histadd('/', substitute(@/, '[?/]', '\="\\%d".char2nr(submatch(0))', 'g'))
	let @@=temp
endfunction

xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<CR>

tnoremap <Esc><Esc> <C-\><C-n>

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
set wildmode=longest:full    " make autocomplete more bash-like

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
set exrc        " use project specific .exrc files
set secure
set gdefault    " substitute all matches on a line

" -- plugins --
if empty(glob('$HOME/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo $HOME/.config/nvim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
augroup PlugInstallGroup
	autocmd!
	autocmd VimEnter * PlugInstall
augroup END
endif
if empty(glob('$HOME/.config/nvim/autoload/plug.vim'))
	silent !mkdir -p $HOME/.config/nvim/autoload
	silent !wget -qO $HOME/.config/nvim/autoload/plug.vim
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
augroup PlugInstallGroup
	autocmd!
	autocmd VimEnter * PlugInstall
augroup END
endif

" plug#begin() automatically calls
" filetype plugin indent on
call plug#begin()
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
	Plug 'Shougo/neomru.vim'
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
	Plug 'fntlnz/atags.vim'
	Plug 'majutsushi/tagbar'
call plug#end()

" netrw
let g:netrw_liststyle=3

" easy-align
nmap <Leader>a <Plug>(EasyAlign)
xmap <Leader>a <Plug>(EasyAlign)

" Sneak
let g:sneak#streak=1

nmap <Leader>s <Plug>Sneak_s
nmap <Leader>S <Plug>Sneak_S
xmap <Leader>s <Plug>Sneak_s
xmap <Leader>S <Plug>Sneak_S
omap <Leader>s <Plug>Sneak_s
omap <Leader>S <Plug>Sneak_S

" replace f with Sneak
nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
xmap f <Plug>Sneak_f
xmap F <Plug>Sneak_F
omap f <Plug>Sneak_f
omap F <Plug>Sneak_F

" replace t with Sneak
nmap t <Plug>Sneak_t
nmap T <Plug>Sneak_T
xmap t <Plug>Sneak_t
xmap T <Plug>Sneak_T
omap t <Plug>Sneak_t
omap T <Plug>Sneak_T

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
nnoremap <Leader>r :Unite neomru/file<CR>
nnoremap <Leader>y :Unite history/yank<CR>

" SnipMate
imap <C-l> <C-r><Tab>

" Neomake
let g:neomake_open_list=2

" atags
nnoremap <Leader>tu :call atags#generate()<CR>

" tagbar
nnoremap <Leader>tb :TagbarToggle<CR>

" load local.init.vim
if !empty(glob('$HOME/.config/nvim/local.init.vim'))
	source $HOME/.config/nvim/local.init.vim
endif
