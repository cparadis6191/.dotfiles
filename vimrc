" -- important --
if !empty(glob('$HOME/.local.vimrc'))
	source $HOME/.local.vimrc
endif

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

set lazyredraw
set number

" -- syntax, highlighting and spelling --
syntax enable                " Turns on syntax highlighting
set hlsearch                 " Highlight search results

" -- multiple windows --
set laststatus=2    " Always show the statusline
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
set undolevels=999                " Increase history size for undoing edits
set backspace=indent,eol,start    " Allow backspace in insert mode
set formatoptions+=j              " Joining comments will remove the comment leader of the lower line
set nojoinspaces                  " Joining lines at punctuation will not insert an extra space

" -- tabs and indenting --
set tabstop=4       " Tab size is 4 spaces
set shiftwidth=0    " Sets < and > shifts to be the value of tabstop
set shiftround      " Rounds to the nearest multiple of shiftwidth when using < and >
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

" Use Q for executing the macro in the q register
nnoremap Q @q

" Search for visual selecions
function! s:VSetSearch()
	let temp=@@
	norm! gvy
	let @/='\V' . substitute(escape(@@, '\'), '\_s\+', '\\_s\\+', 'g')
	call histadd('/', substitute(@/, '[?/]', '\="\\%d".char2nr(submatch(0))', 'g'))
	let @@=temp
endfunction

xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<CR>

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
set gdefault                   " Use the 'g' flag for ':substitute'
set sessionoptions-=options    " Do not save options in sessions

" -- plugins --
if empty(glob('$HOME/.vim/autoload/plug.vim'))
	silent !curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
augroup PlugInstallGroup
	autocmd!
	autocmd VimEnter * PlugInstall
augroup END
endif
if empty(glob('$HOME/.vim/autoload/plug.vim'))
	silent !mkdir -p $HOME/.vim/autoload
	silent !wget -qO $HOME/.vim/autoload/plug.vim
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
	Plug 'https://github.com/junegunn/vim-easy-align'
	Plug 'https://github.com/justinmk/vim-sneak.git'
	Plug 'https://github.com/mbbill/undotree'
	Plug 'https://github.com/tpope/vim-commentary'
	Plug 'https://github.com/tpope/vim-repeat'
	Plug 'https://github.com/tpope/vim-surround'
	Plug 'https://github.com/tpope/vim-unimpaired'

	" display
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

	" programming
	Plug 'https://github.com/airblade/vim-gitgutter'
	Plug 'https://github.com/neomake/neomake'
	Plug 'https://github.com/tpope/vim-fugitive'

	" tags
	Plug 'https://github.com/xolox/vim-misc'
	Plug 'https://github.com/xolox/vim-easytags', {'on': ['UpdateTags', 'HighlightTags']}
	Plug 'https://github.com/majutsushi/tagbar'
call plug#end()

" netrw
let g:netrw_liststyle=3

" easy-align
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" Sneak
nmap <Leader>s <Plug>Sneak_s
nmap <Leader>S <Plug>Sneak_S
xmap <Leader>s <Plug>Sneak_s
xmap <Leader>S <Plug>Sneak_S
omap <Leader>s <Plug>Sneak_s
omap <Leader>S <Plug>Sneak_S

" Replace f with Sneak
nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
xmap f <Plug>Sneak_f
xmap F <Plug>Sneak_F
omap f <Plug>Sneak_f
omap F <Plug>Sneak_F

" Replace t with Sneak
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
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
nnoremap <Leader>b :Unite buffer<CR>
nnoremap <Leader>f :Unite -start-insert file_rec/neovim<CR>
nnoremap <Leader>g :Unite vimgrep<CR><CR>
nnoremap <Leader>l :Unite -start-insert locate<CR>
nnoremap <Leader>r :Unite neomru/file<CR>
nnoremap <Leader>y :Unite history/yank<CR>

" SnipMate
imap <C-L> <C-R><Tab>

" Git Gutter
let g:gitgutter_sign_column_always=1

" Neomake
let g:neomake_open_list=2

" easytags
let g:easytags_dynamic_files=2
let g:easytags_always_enabled=0
let g:easytags_auto_update=0
nnoremap <Leader>tu :UpdateTags<CR>
nnoremap <Leader>tru :UpdateTags -R<CR>

" tagbar
nnoremap <Leader>tb :TagbarToggle<CR>
