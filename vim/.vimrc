" -- important --
let $VIMFILES=split(&runtimepath, '[^\\]\zs,')[0]

" -- plugins --
if empty(glob($VIMFILES.'/autoload/plug.vim'))
	silent !curl --create-dirs --location --output $VIMFILES/autoload/plug.vim
	    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	augroup PlugInstallGroup
		autocmd!
		autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
	augroup END
endif

call plug#begin()
	" vim-neovim-defaults
	if !has('nvim')
		Plug 'cparadis6191/vim-neovim-defaults'
	endif

	" Displaying text
	Plug 'bronson/vim-trailing-whitespace'
	Plug 'junegunn/rainbow_parentheses.vim'
	Plug 'justinmk/vim-dirvish'

	" Editing text
	Plug 'junegunn/vim-easy-align'
	Plug 'mbbill/undotree'
	Plug 'tpope/vim-commentary'
	Plug 'tpope/vim-repeat'
	Plug 'tpope/vim-surround'

	" Git
	Plug 'mhinz/vim-signify'
	Plug 'tpope/vim-fugitive'

	" neosnippet
	Plug 'Shougo/neosnippet.vim'
	Plug 'Shougo/neosnippet-snippets'

	" Unite
	Plug 'Shougo/unite.vim'
	Plug 'Shougo/neoyank.vim'
	Plug 'rhysd/unite-oldfiles.vim'
	Plug 'sgoranson/unite-mark'
	Plug 'ujihisa/unite-locate'
call plug#end()

if !has('nvim')
	runtime plugin/neovim_defaults.vim
endif

" -- plugin settings --
" mapleader must be set BEFORE <Leader> mappings are used
let mapleader=' '

" Displaying text
" Rainbow Parentheses
let g:rainbow#blacklist=[0, 255]
let g:rainbow#pairs=[['(', ')'], ['[', ']'], ['{', '}']]
augroup RainbowParenthesesGroup
	autocmd!
	autocmd VimEnter * RainbowParentheses
augroup END

" dirvish
let g:dirvish_relative_paths=1
augroup DirvishGroup
	autocmd!
	autocmd Filetype dirvish nmap <buffer> h <Plug>(dirvish_up)
	autocmd Filetype dirvish nmap <buffer> l <CR>
augroup END

" Editing text
" easy-align
nmap <Leader>a <Plug>(EasyAlign)
xmap <Leader>a <Plug>(EasyAlign)

" undotree
nnoremap <Leader>u :UndotreeToggle<CR>

" Git
" signify
highlight SignifySignDelete cterm=bold ctermbg=1
highlight SignifySignAdd cterm=bold ctermbg=2
highlight SignifySignChange cterm=bold ctermbg=3

" fugitive
nnoremap <Leader>gb :Git blame<CR>
nnoremap <Leader>gd :Gvdiffsplit<CR>
nnoremap <Leader>ge :Gedit<CR>
nnoremap <Leader>gg :Ggrep <C-R>=expand('<cword>')<CR>
nnoremap <Leader>gl :0Gclog<CR>
nnoremap <Leader>gs :Git<CR>

" neosnippet
imap <expr> <Tab> neosnippet#expandable_or_jumpable() ? '<Plug>(neosnippet_expand_or_jump)' : '<Tab>'
smap <expr> <Tab> neosnippet#expandable_or_jumpable() ? '<Plug>(neosnippet_expand_or_jump)' : '<Tab>'
xmap <Tab> <Plug>(neosnippet_expand_target)

" Unite
let g:unite_enable_auto_select=0

call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_length'])

" Unite custom sources
call unite#custom#source('oldfiles', 'sorters', 'sorter_nothing')

" Unite mappings
nnoremap <Leader>b :Unite buffer<CR>
if !has('nvim')
	nnoremap <Leader>f :Unite -start-insert file_rec<CR>
else
	nnoremap <Leader>f :Unite -start-insert file_rec/neovim<CR>
endif
nnoremap <Leader>l :Unite -start-insert locate<CR>
nnoremap <Leader>' :Unite mark<CR>
nnoremap <Leader>r :Unite oldfiles<CR>
nnoremap <Leader>s :Unite -start-insert neosnippet<CR>
nnoremap <Leader>y :Unite history/yank<CR>

" -- mappings --
" Repeat the previous recording
nnoremap Q @@
xnoremap Q :normal! @@<CR>

" Make Y behave more like C and D
nnoremap Y y$

nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [b :bprevious<CR>

" Jump to Git conflict markers
noremap ]g /\V\^\[<<Bar>=>]\{7}<CR>
noremap [g ?\V\^\[<<Bar>=>]\{7}<CR>

nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [q :cprevious<CR>

nnoremap <silent> ]Q :cnfile<CR>
nnoremap <silent> [Q :cpfile<CR>

" Swap visual
xnoremap <Leader>s :<C-U> normal! `.``gvP``P<CR>

" Get visual
function! s:GetVisual()
	let l:unnamed_reg=@"
	normal! gvy
	let l:visual='\V'.substitute(escape(@", '/\'), '\_s\+', '\\_s\\+', 'g')
	let @"=l:unnamed_reg
	return l:visual
endfunction

" Set search
function! s:SetSearch(pattern)
	let @/=a:pattern
	call histadd('search', @/)
endfunction

" Set search mappings
xnoremap * :<C-U>call <SID>SetSearch(<SID>GetVisual())<CR>/<CR>
xnoremap # :<C-U>call <SID>SetSearch(<SID>GetVisual())<CR>?<CR>

" Append search
function! s:AppendSearch(pattern)
	call <SID>SetSearch(@/.'\|'.a:pattern)
endfunction

" Append search mappings
nnoremap <Leader>* :<C-U>call <SID>AppendSearch('\<'.expand('<cword>').'\>')<CR>/<CR>
nnoremap <Leader># :<C-U>call <SID>AppendSearch('\<'.expand('<cword>').'\>')<CR>?<CR>

xnoremap <Leader>* :<C-U>call <SID>AppendSearch(<SID>GetVisual())<CR>/<CR>
xnoremap <Leader># :<C-U>call <SID>AppendSearch(<SID>GetVisual())<CR>?<CR>

nnoremap <Leader>g* :<C-U>call <SID>AppendSearch(expand('<cword>'))<CR>/<CR>
nnoremap <Leader>g# :<C-U>call <SID>AppendSearch(expand('<cword>'))<CR>?<CR>

" Highlight the last search more permanently
nnoremap <silent> <Leader>/ :match Search /<C-R>=@/<CR>/<CR>

" Diff unwritten changes
function! s:DiffUnwrittenChanges()
	let l:filetype=&filetype | diffthis
	vnew | read # | 1d
	setlocal bufhidden=wipe buftype=nofile nobuflisted nomodifiable nomodified
	augroup DiffUnwrittenChangesGroup
		autocmd!
		autocmd BufWinLeave <buffer> diffoff!
	augroup END
	diffthis | let &filetype=l:filetype
endfunction

nnoremap <Leader>d :call <SID>DiffUnwrittenChanges()<CR>

" Jump to where the last change was made
noremap <Leader>e `.

" Open alternate file
nnoremap <Leader>ga :edit <C-R>=expand('%:r')<CR>.

" Put the last yanked thing
nnoremap <Leader>p "0p
nnoremap <Leader>P "0P

if exists(':terminal')
	tnoremap <Esc><Esc> <C-\><C-N>
	if !has('nvim')
		nnoremap <Leader>t :terminal<CR>
	else
		nnoremap <Leader>t :below split <Bar> terminal<CR>
		augroup TerminalGroup
			autocmd!
			autocmd TermOpen * startinsert
		augroup END
	endif
endif

" Cscope mappings
nnoremap <C-\> :cscope find <Space><C-R>=expand('<cword>')<CR><S-Left><S-Left>

" Add Cscope databases that neighbor tags files
function! s:CscopeAddDatabases()
	for l:tagfile in tagfiles()
		let l:cscopedb=findfile('cscope.out', fnamemodify(l:tagfile, ':p:h').matchstr(l:tagfile[-1:], ';'))
		if !empty(glob(l:cscopedb))
			execute 'cscope add' l:cscopedb
		endif
	endfor
endfunction

nnoremap <silent> <Leader>tl :call <SID>CscopeAddDatabases()<CR>

" -- moving around, searching and patterns --
set ignorecase
set smartcase

" -- tags --
set tags+=./.git/tags;
set cscopetag

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

" -- multiple windows --
let &statusline=' %<%f [%{(&fileencoding ? &fileencoding : &encoding)}] %y%m%r %{(exists("g:loaded_fugitive")) ? fugitive#statusline() : ""} %= %-3b %-4(0x%B%) %-12(%5(%l,%)%c%V%) %P '
set hidden
set splitbelow
set splitright

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
set nojoinspaces

" -- tabs and indenting --
set tabstop=4
set shiftwidth=0
set shiftround
set copyindent

" -- folding --
" -- diff mode --
" -- mapping --

" -- reading and writing files --
set backup
if empty(glob($VIMFILES.'/backup'))
	call mkdir($VIMFILES.'/backup', 'p')
endif
set backupdir^=$VIMFILES/backup//

" -- the swap file --
if empty(glob($VIMFILES.'/swap'))
	call mkdir($VIMFILES.'/swap', 'p')
endif
set directory^=$VIMFILES/swap//

" -- command line editing --
set wildmode=longest:full    " Make autocomplete more like bash

set undofile
if empty(glob($VIMFILES.'/undo'))
	call mkdir($VIMFILES.'/undo', 'p')
endif
set undodir^=$VIMFILES/undo//

" -- executing external commands --

" -- running make and jumping to errors --
if executable('rg')
	let &grepprg='rg --vimgrep'
endif

" -- language specific --
" -- multi-byte characters --

" -- various --
set exrc
set secure

if exists('+inccommand')
	set inccommand=nosplit
endif

" Load local config
if !has('nvim')
	if !empty(glob($HOME.'/.vimrc.local'))
		source $HOME/.vimrc.local
	endif
else
	if !empty(glob($VIMFILES.'/local.init.vim'))
		source $VIMFILES/local.init.vim
	endif
endif
