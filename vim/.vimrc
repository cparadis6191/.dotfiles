" -- config directory --
let $VIMFILES = split(&runtimepath, '[^\\]\zs,')[0]

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
	Plug '~/.vim/plugin/journal'

	" Editing text
	Plug 'junegunn/vim-easy-align'
	Plug 'mbbill/undotree'
	Plug 'tpope/vim-abolish'
	Plug 'tpope/vim-commentary'
	Plug 'tpope/vim-repeat'
	Plug 'tpope/vim-surround'
	Plug '~/.vim/plugin/visual_selection'
	Plug '~/.vim/plugin/search'
	Plug '~/.vim/plugin/normal_expr'

	" fzf
	Plug 'junegunn/fzf'
	Plug 'junegunn/fzf.vim'
	Plug '~/.vim/plugin/fzf_neosnippets'
	Plug '~/.vim/plugin/fzf_quickfix'

	" Git
	Plug 'mhinz/vim-signify'
	Plug 'tpope/vim-fugitive'

	" neosnippet
	Plug 'Shougo/neosnippet.vim'
	Plug 'Shougo/neosnippet-snippets'

	" Note
	Plug '~/.vim/plugin/note'

	" Tree-sitter
	if has('nvim')
		Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
		Plug '~/.config/nvim/plugin/treesitter.vim'
	endif
call plug#end()

" vim-neovim-defaults
if !has('nvim')
	runtime plugin/neovim_defaults.vim
endif

" -- plugin settings --
" Disable built-in plugins
" See :h netrw-noload
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

let g:loaded_tutor_mode_plugin = 1

" Displaying text
" dirvish
let g:dirvish_relative_paths = 1

" Git
" signify
" Only allow signify to use Git. Note that this can greatly reduce startup
" time.
let g:signify_skip = {'vcs': {'allow': ['git']}}

" -- plugin mappings --
" mapleader must be set BEFORE <Leader> mappings are used
let mapleader = ' '

" Editing text
" fzf
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>l :Locate<Space>
nnoremap <Leader>m :Marks<CR>
nnoremap <Leader>n :Files <C-R>=expand('%:h')<CR><CR>
nnoremap <Leader>o :History<CR>

" Git quickfix
nnoremap <Leader>gq :GitQuickfix<Space>

" fugitive
nnoremap <Leader>gb :Git blame<CR>
xnoremap <Leader>gb :Git blame<CR>
nnoremap <Leader>gd :rightbelow Gvdiffsplit HEAD
nnoremap <Leader>ge :Gedit<CR>
nnoremap <Leader>gg :Ggrep <C-R>=expand('<cword>')<CR>
nnoremap <Leader>gl :Gclog!<CR>
xnoremap <Leader>gl :Gclog!<CR>

" Markdown
let g:markdown_fenced_languages=['bash', 'c', 'cpp', 'python', 'sh']
let g:markdown_folding = 1

" neosnippet
imap <expr> <Tab> neosnippet#expandable_or_jumpable() ? '<Plug>(neosnippet_expand_or_jump)' : '<Tab>'
smap <expr> <Tab> neosnippet#expandable_or_jumpable() ? '<Plug>(neosnippet_expand_or_jump)' : '<Tab>'
xmap <Tab> <Plug>(neosnippet_expand_target)

" -- functions --
" Diff unwritten changes
" See :h :DiffOrig
function! s:DiffUnwrittenChanges()
	let l:filetype = &filetype
	diffthis
	rightbelow vnew
	" Set modifiable so the scratch buffer can be used again
	set modifiable
	read ++edit # | 1delete _
	let &filetype = l:filetype | set bufhidden=wipe buftype=nofile nomodifiable nomodified
	diffthis
	wincmd p
endfunction

" Git quickfix
function! s:GitQuickfix(command_string, bang)
	" Don't jump to the first error when a:bang is TRUE
	execute printf('%s system(%s)', a:bang ? 'cgetexpr' : 'cexpr', shellescape(printf('git quickfix %s', a:command_string)))
endfunction

" Restore cursor
" See :h restore-cursor
function! s:RestoreCursor()
	if line("'\"") > 1 && line("'\"") <= line('$')
		if &filetype !~# 'commit\|rebase'
			normal! g`"
		endif
	endif
endfunction

" -- commands --
" Git quickfix
command! -bang -nargs=1 GitQuickfix call <SID>GitQuickfix(<q-args>, <bang>0)

" -- mappings --
" Search inside the visual selection
vnoremap g/ <Esc>/\%V
vnoremap g? <Esc>/\%V

" Jump to where the last change was made
nnoremap <Leader>c `.
onoremap <Leader>c `.
xnoremap <Leader>c `.

nnoremap <Leader>d :silent call <SID>DiffUnwrittenChanges()<CR>

" Open alternate file
nnoremap <Leader>ea :edit <C-R>=expand('%:r')<CR>.

" Repeat the previous recording
" Note that this mapping supports a count
nnoremap Q @@

" Run visual selection as a command
xnoremap <silent> <Leader>r :<C-U>echo system(visual_selection#get_from_normal())<CR>

" Run visual selection as a command and insert its standard output below the
" cursor.
xnoremap <silent> <Leader>R :<C-U>read !<C-R>=substitute(visual_selection#get_from_normal(), '\n', ';', 'g')<CR><CR>

" Make Y behave more like C and D
nnoremap Y y$

nnoremap ]b :<C-U><C-R>=(v:count ? v:count : '')<CR>bnext<CR>
nnoremap [b :<C-U><C-R>=(v:count ? v:count : '')<CR>bprevious<CR>

" Jump to Git conflict markers
" Note that these mappings support count
nnoremap ]g /\V\^\[<<Bar>=>]\{7}<CR>
onoremap ]g /\V\^\[<<Bar>=>]\{7}<CR>
xnoremap ]g /\V\^\[<<Bar>=>]\{7}<CR>
nnoremap [g ?\V\^\[<<Bar>=>]\{7}<CR>
onoremap [g ?\V\^\[<<Bar>=>]\{7}<CR>
xnoremap [g ?\V\^\[<<Bar>=>]\{7}<CR>

nnoremap ]q :<C-U><C-R>=(v:count ? v:count : '')<CR>cnext<CR>
onoremap ]q :<C-U><C-R>=(v:count ? v:count : '')<CR>cnext<CR>
xnoremap ]q :<C-U><C-R>=(v:count ? v:count : '')<CR>cnext<CR>``gv``
nnoremap [q :<C-U><C-R>=(v:count ? v:count : '')<CR>cprevious<CR>
onoremap [q :<C-U><C-R>=(v:count ? v:count : '')<CR>cprevious<CR>
xnoremap [q :<C-U><C-R>=(v:count ? v:count : '')<CR>cprevious<CR>``gv``

nnoremap ]Q :<C-U><C-R>=(v:count ? v:count : '')<CR>cnfile<CR>
nnoremap [Q :<C-U><C-R>=(v:count ? v:count : '')<CR>cpfile<CR>

" Highlight the last search more permanently
nnoremap <Leader>/ :<C-U><C-R>=(v:count ? v:count : '')<CR>match Search /<C-R>=@/<CR>/<CR>

" -- plugin autocommands --
" Displaying text
" dirvish
augroup DirvishGroup
	autocmd!
	autocmd FileType dirvish nmap <buffer> h <Plug>(dirvish_up)
	autocmd FileType dirvish nmap <buffer> l <CR>
augroup END

" -- autocommands --
" Restore cursor
augroup RestoreCursorGroup
	autocmd!
	autocmd BufReadPost * call <SID>RestoreCursor()
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
	let &showbreak = '  > '
endif

set lazyredraw
set number

" -- syntax, highlighting and spelling --
set termguicolors

" -- multiple windows --
let &statusline = ' %f [%{&fileencoding != "" ? &fileencoding : &encoding}]%( %y%)'
let &statusline .= '%( %{FugitiveStatusline()}%)%( %{sy#repo#get_stats_decorated()}%)%( %m%r%) %='
let &statusline .= '%< %-3b %-4(0x%B%) %-12(%5(%l,%)%c%V%) %P '
set hidden

" -- multiple tab pages --

" -- terminal --
set title

" -- using the mouse --
set mouse=nv
set mousemodel=extend

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
set wildmode=longest,list

set undofile
if empty(glob($VIMFILES.'/undo'))
	call mkdir($VIMFILES.'/undo', 'p')
endif
set undodir^=$VIMFILES/undo//

" -- executing external commands --

" -- running make and jumping to errors --
if executable('rg')
	let &grepprg = 'rg --vimgrep'
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
	if !empty(glob($HOME.'/.local/etc/.vimrc'))
		source $HOME/.local/etc/.vimrc
	endif
else
	if !empty(glob($HOME.'/.local/etc/.config/nvim/init.vim'))
		source $HOME/.local/etc/.config/nvim/init.vim
	endif
endif
