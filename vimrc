" Referenced here: http://vimuniversity.com/samples/your-first-vimrc-should-be-nearly-empty
" Original Author:	 Bram Moolenaar <Bram@vim.org>
" Made more minimal by:  Ben Orenstein
" Last change:	         2012 Jan 20

" This must be first, because it changes other options as a side effect.
set nocompatible

" Make backspace behave in a sane manner.
set backspace=indent,eol,start


" Switch syntax highlighting on
if !exists("syntax_on")
	syntax on
endif

" Enable file type detection and do language-dependent indenting.
filetype plugin indent on


" Tab Options
" makes tabs smaller
set tabstop=4
set shiftwidth=4


" Indenting
set autoindent
set smartindent
set cindent


" Search Options
set ignorecase
set smartcase
set hlsearch
set incsearch
set wrapscan


" Misc Options
" Shows the current line number in lower right corner
set ruler

" Scrolls when 3 lines from bottom of page
set scrolloff=3
