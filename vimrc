" .vimrc - Save this file as .vimrc in your home directory. (e.g. /home/user/.vimrc)
" Author: Chad Paradis


" -- important --
set nocompatible	" Use the full power of Vim

" -- moving around, searching and patterns --
set hlsearch		" Highlight search results
set incsearch		" Jumps to the first match while typing
set ignorecase		" When doing a search, ignore the case of letters
set smartcase		" Override the ignorecase option if the search pattern contains upper case letters

" -- tags --

" -- displaying text --
set scrolloff=5		" Keep the cursor at least five lines from the bottom or top
set linebreak		" Wrap lines at a convenient place

" -- syntax, highlighting and spelling --
syntax enable		" Turns on syntax highlighting
filetype indent on	" Do smart indenting when starting a new line

" -- multiple windows --
set hidden			" Hide buffers instead of closing them

" -- multiple tab pages --

" -- terminal --
set title			" Set the window title properly when running in certain shells

" -- using the mouse --
" -- printing --

" -- messages and info --
set ruler			" Information about cursor placement
set showcmd			" Show incomplete commands at the bottom

" -- selecting text --

" -- editing text --
set backspace=indent,eol,start	" Allow backspace in insert mode

set undolevels=1000	" Increase history size for undoing edits

" -- tabs and indenting --
set noexpandtab		" Strictly use tabs when tab is pressed (this is the default)
set tabstop=4		" Tab size is 4 spaces
set shiftwidth=4	" Sets << and >> shifts to be 4 characters
set shiftround		" When using << and >> rounds to the nearest multiple of shiftwidth

set autoindent		" Copy indent from current line when starting a new line

" -- folding --
set foldmethod=indent
set foldlevelstart=99	" Buffers start with all folds open

" -- diff mode --

" -- mapping --
nnoremap j gj		" Navigate wrapped lines in a sane way
nnoremap k gk
nnoremap 0 g0
nnoremap $ g$

nnoremap <c-h> gT	" Use <C-H> and <C-L> to cycle through tabs
nnoremap <c-l> gt

nnoremap gf <c-w>gf	" Open file under cursor in new tab
nnoremap gF <c-w>gF	" Open file under cursor in new tab and jump to line number

" -- reading and writing files --

" -- the swap file --

" -- command line editing --
set history=1000	" Increase history size for commands and search patterns

set wildmenu		" List external files instead of just autocompleting
set wildoptions=tagfile	" List autocomplete for command line options

" -- executing external commands --
" -- running make and jumping to errors --
" -- language specific --
" -- multi-byte characters --
" -- various --

