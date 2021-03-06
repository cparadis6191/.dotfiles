" -- config directory --
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
	Plug 'rhysd/unite-oldfiles.vim'
	Plug 'ujihisa/unite-locate'
call plug#end()

" vim-neovim-defaults
if !has('nvim')
	runtime plugin/neovim_defaults.vim
endif

" -- plugin settings --
" mapleader must be set BEFORE <Leader> mappings are used
let mapleader=' '

" Displaying text
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

" Git
" signify
highlight SignifySignDelete cterm=bold ctermbg=1
highlight SignifySignAdd cterm=bold ctermbg=2
highlight SignifySignChange cterm=bold ctermbg=3

" fugitive
nnoremap <Leader>gb :Git blame<CR>
nnoremap <Leader>gd :rightbelow Gvdiffsplit<CR>
nnoremap <Leader>ge :Gedit<CR>
nnoremap <Leader>gg :Ggrep <C-R>=expand('<cword>')<CR>
nnoremap <Leader>gl :0Gclog<CR>
xnoremap <Leader>gl :Gclog<CR>
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
nnoremap <Leader>o :Unite oldfiles<CR>
nnoremap <Leader>s :Unite -start-insert neosnippet<CR>

" -- mappings --
" Jump to where the last change was made
nnoremap <Leader>c `.
onoremap <Leader>c `.
xnoremap <Leader>c `.

" Diff unwritten changes
" See :h :DiffOrig
function! s:DiffUnwrittenChanges()
	let l:filetype=&filetype
	diffthis
	rightbelow vnew | read ++edit # | 1delete _
	let &filetype=l:filetype | set bufhidden=wipe buftype=nofile nobuflisted nomodifiable nomodified
	diffthis
endfunction

nnoremap <Leader>d :call <SID>DiffUnwrittenChanges()<CR>

" Open alternate file
nnoremap <Leader>ea :edit <C-R>=expand('%:r')<CR>.

" Execute normal mode commands for each line in the range. Before executing
" the commands, the cursor is positioned in the virtual column that the cursor
" was in when the function was called, for each line.
function! s:RangeNormalAtVirtCol(count, command)
	return ':normal! '.getcurpos()[4].'|'.a:count.a:command."\<CR>"
endfunction

" Repeat the previous recording
" Note that this mapping supports count
nnoremap Q @@
xnoremap <silent> <expr> Q <SID>RangeNormalAtVirtCol(v:count1, '@@')

" Repeat last change on visual selection
xnoremap <silent> <expr> . <SID>RangeNormalAtVirtCol(v:count ? v:count : '', '.')

" Get visual selection
" Note that this function must be called from visual mode
function! s:GetVisualSelection()
	let l:unnamed_reg=@"
	normal! y
	let l:visual=@"
	let @"=l:unnamed_reg
	return l:visual
endfunction

" Get visual selection from normal
function! s:GetVisualSelectionFromNormal()
	normal! gv
	return <SID>GetVisualSelection()
endfunction

" Run visual selection as a command
xnoremap <silent> <Leader>r :<C-U>echo system(<SID>GetVisualSelectionFromNormal())<CR>

" Swap current visual selection with last deleted visual selection
xnoremap <Leader>s :<C-U>normal! `.``gv<C-R>=v:count1<CR>p``<C-R>=v:count1<CR>P<CR>

" Make Y behave more like C and D
nnoremap Y y$

nnoremap <silent> ]b :<C-U><C-R>=v:count1<CR>bnext<CR>
nnoremap <silent> [b :<C-U><C-R>=v:count1<CR>bprevious<CR>

" Jump to Git conflict markers
" Note that these mappings support count
nnoremap ]g /\V\^\[<<Bar>=>]\{7}<CR>
onoremap ]g /\V\^\[<<Bar>=>]\{7}<CR>
xnoremap ]g /\V\^\[<<Bar>=>]\{7}<CR>
nnoremap [g ?\V\^\[<<Bar>=>]\{7}<CR>
onoremap [g ?\V\^\[<<Bar>=>]\{7}<CR>
xnoremap [g ?\V\^\[<<Bar>=>]\{7}<CR>

nnoremap <silent> ]q :<C-U><C-R>=v:count1<CR>cnext<CR>
onoremap <silent> ]q :<C-U><C-R>=v:count1<CR>cnext<CR>
xnoremap <silent> ]q :<C-U><C-R>=v:count1<CR>cnext<CR>``gv``
nnoremap <silent> [q :<C-U><C-R>=v:count1<CR>cprevious<CR>
onoremap <silent> [q :<C-U><C-R>=v:count1<CR>cprevious<CR>
xnoremap <silent> [q :<C-U><C-R>=v:count1<CR>cprevious<CR>``gv``

nnoremap <silent> ]Q :<C-U><C-R>=v:count1<CR>cnfile<CR>
nnoremap <silent> [Q :<C-U><C-R>=v:count1<CR>cpfile<CR>

if exists(':terminal')
	tnoremap <Esc><Esc> <C-\><C-N>
	if !has('nvim')
		nnoremap <Leader>t :terminal<CR>
	else
		nnoremap <Leader>t :split <Bar> terminal<CR>
	endif
endif

" Escape search
function! s:EscapeSearch(pattern)
	return '\V'.substitute(escape(a:pattern, '/\'), '\_s\+', '\\_s\\+', 'g')
endfunction

" Word search
function! s:WordSearch(pattern)
	return '\<'.a:pattern.'\>'
endfunction

" Append search
function! s:AppendSearch(pattern)
	return @/.'\|'.a:pattern
endfunction

" Set search mappings
" Note that these mappings support count
" This makes the search also find matches that are not a whole word
xnoremap * /<C-R>=<SID>EscapeSearch(<SID>GetVisualSelection())<CR><CR>
xnoremap # ?<C-R>=<SID>EscapeSearch(<SID>GetVisualSelection())<CR><CR>

" Only whole keywords are searched for
xnoremap g* /<C-R>=<SID>WordSearch(<SID>EscapeSearch(<SID>GetVisualSelection()))<CR><CR>
xnoremap g# ?<C-R>=<SID>WordSearch(<SID>EscapeSearch(<SID>GetVisualSelection()))<CR><CR>

" Append search mappings
" Only whole keywords are searched for
nnoremap <Leader>* /<C-R>=<SID>AppendSearch(<SID>WordSearch(expand('<cword>')))<CR><CR>
nnoremap <Leader># ?<C-R>=<SID>AppendSearch(<SID>WordSearch(expand('<cword>')))<CR><CR>

" This makes the search also find matches that are not a whole word
nnoremap <Leader>g* /<C-R>=<SID>AppendSearch(expand('<cword>'))<CR><CR>
nnoremap <Leader>g# ?<C-R>=<SID>AppendSearch(expand('<cword>'))<CR><CR>

" This makes the search also find matches that are not a whole word
xnoremap <Leader>* /<C-R>=<SID>AppendSearch(<SID>EscapeSearch(<SID>GetVisualSelection()))<CR><CR>
xnoremap <Leader># ?<C-R>=<SID>AppendSearch(<SID>EscapeSearch(<SID>GetVisualSelection()))<CR><CR>

" Only whole keywords are searched for
xnoremap <Leader>g* /<C-R>=<SID>AppendSearch(<SID>WordSearch(<SID>EscapeSearch(<SID>GetVisualSelection())))<CR><CR>
xnoremap <Leader>g# ?<C-R>=<SID>AppendSearch(<SID>WordSearch(<SID>EscapeSearch(<SID>GetVisualSelection())))<CR><CR>

" Highlight the last search more permanently
nnoremap <silent> <Leader>/ :match Search /<C-R>=@/<CR>/<CR>

" -- autocommands --
" Restore cursor
" See :h restore-cursor
augroup RestoreCursorGroup
	autocmd!
	autocmd BufReadPost *
		\ if line("'\"") >= 1 && line("'\"") <= line('$') && &filetype !~# 'commit' |
			\ execute 'normal! g`"' |
		\ endif
augroup END

" -- options --
" -- important --
" Don't overwrite a readonly file
set cpoptions+=W

" -- moving around, searching and patterns --
set ignorecase
set smartcase

" -- tags --
set tags+=./.git/tags;

" -- displaying text --
set scrolloff=5
set sidescrolloff=5
set linebreak

if exists('+breakindent')
	set breakindent
	let &showbreak='  > '
endif

set lazyredraw
set number

" -- syntax, highlighting and spelling --
" Workaround for poor Neovim undercurl/underline support
if has('nvim')
    augroup SpellBadGroup
        autocmd!
        autocmd ColorScheme * highlight SpellBad guibg=Red
        autocmd ColorScheme * highlight SpellCap guibg=Blue
    augroup END
endif

set termguicolors

" -- multiple windows --
let &statusline=' %<%f [%{(&fileencoding != "" ? &fileencoding : "utf-8")}] %y%m%r %{(exists("g:loaded_fugitive")) ? fugitive#statusline() : ""} %= %-3b %-4(0x%B%) %-12(%5(%l,%)%c%V%) %P '
set hidden

" -- multiple tab pages --

" -- terminal --
set title

" -- using the mouse --
" -- printing --

" -- messages and info --
set showcmd

" -- selecting text --

" -- editing text --
set nojoinspaces

" -- tabs and indenting --
set tabstop=4
set shiftwidth=0
set shiftround
set copyindent

" -- folding --
set foldlevelstart=99
set foldmethod=syntax

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
" Make autocomplete more like bash
set wildmode=longest:full

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
