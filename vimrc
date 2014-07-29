" .vimrc - Save this file as .vimrc in your home directory. (e.g. /home/user/.vimrc)
" Author: Chad Paradis


" -- important --
set nocompatible    " Use the full power of Vim

" -- moving around, searching and patterns --
set hlsearch        " Highlight search results
set incsearch       " Jumps to the first match while typing
set ignorecase      " When doing a search, ignore the case of letters
set smartcase       " Override the ignorecase option if the search pattern contains upper case letters

" -- tags --

" -- displaying text --
set scrolloff=5     " Keep the cursor at least five lines from the bottom or top
set linebreak       " Wrap lines at a convenient place

" -- syntax, highlighting and spelling --
syntax enable       " Turns on syntax highlighting
filetype indent on  " Do smart indenting when starting a new line

" -- multiple windows --
set hidden          " Hide buffers instead of closing them

" -- multiple tab pages --
set tabpagemax=99	" Increase the max number of tabs opened at once

" -- terminal --
set title           " Set the window title properly when running in certain shells

" -- using the mouse --
" -- printing --

" -- messages and info --
set ruler           " Information about cursor placement
set showcmd         " Show incomplete commands at the bottom

" -- selecting text --

" -- editing text --
set backspace=indent,eol,start  " Allow backspace in insert mode

set undolevels=1000 " Increase history size for undoing edits

" -- tabs and indenting --
set noexpandtab     " Strictly use tabs when tab is pressed (this is the default)
set tabstop=4       " Tab size is 4 spaces
set shiftwidth=4    " Sets << and >> shifts to be 4 characters
set shiftround      " When using << and >> rounds to the nearest multiple of shiftwidth

set autoindent      " Copy indent from current line when starting a new line

" -- folding --
set foldmethod=indent
set foldlevelstart=99    " Buffers start with all folds open

" -- diff mode --

" -- mapping --
" Comments CANNOT be on the same line as a map
" Navigate wrapped lines in a sane way
nnoremap j gj
nnoremap k gk
nnoremap 0 g0
nnoremap $ g$

" Make Y behave more like C and D
nnoremap Y y$

" Use <C-H> and <C-L> to cycle through tabs
nnoremap <c-l> gt
nnoremap <c-h> gT

" Open file under cursor in new tab
nnoremap gf <c-w>gf
" Open file under cursor in new tab and jump to line number
nnoremap gF <c-w>gF

" Shifting in visual mode now reselects the block
vnoremap > >gv
vnoremap < <gv

" -- reading and writing files --
" -- the swap file --

" -- command line editing --
set history=1000    " Increase history size for commands and search patterns

set wildmenu        " List external files instead of just autocompleting
set wildoptions=tagfile    " List autocomplete for command line options

" -- executing external commands --
" -- running make and jumping to errors --
" -- language specific --
" -- multi-byte characters --
" -- various --

" -- plugins --
execute pathogen#infect()

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<c-t>'],
    \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
\ }

let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound    " ()
au Syntax * RainbowParenthesesLoadSquare   " []
au Syntax * RainbowParenthesesLoadBraces   " {}
