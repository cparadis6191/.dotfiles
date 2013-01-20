" .vimrc file - Save this file as .vimrc in your home directory. (e.g. /home/user/.vimrc)

" Author: Chad Paradis

" -- General --
set nocompatible

" -- Programming --
set autoindent		"Copy indent from current line when starting a new line
set smartindent		"Do smart indenting when starting a new line. Works with supported c-like languages

syntax on			"Turns on syntax highlighting

" -- Spaces/Tabs --
set noexpandtab		"Strictly use tabs when tab is pressed (this is the default)
set shiftwidth=4	"Sets tabs to be 4 characters wide
set tabstop=4

" -- Searching --
set hlsearch		"Highlight search results
set ignorecase		"When doing a search, ignore the case of letters
set smartcase		"Override the ignorecase option if the search pattern contains upper case letters

" -- Tabbed Editing --

" -- Tweaks --
set backspace=indent,eol,start	"Add tweak for better backspace support
set ruler			"Information about cursor placement
set scrolloff=3		"Keep the cursor at least three lines from the bottom

" -- File Format --
"set fileformats=unix,dos,mac	"Allows all file formats to be read
"autocmd BufWritePre * set fileformat=unix	"Always writes files with unix line endings
