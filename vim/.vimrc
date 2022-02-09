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

	" Editing text
	Plug 'junegunn/vim-easy-align'
	Plug 'mbbill/undotree'
	Plug 'tpope/vim-commentary'
	Plug 'tpope/vim-repeat'
	Plug 'tpope/vim-surround'

	" fzf
	Plug 'junegunn/fzf'
	Plug 'junegunn/fzf.vim'

	" Git
	Plug 'mhinz/vim-signify'
	Plug 'tpope/vim-fugitive'

	" neosnippet
	Plug 'Shougo/neosnippet.vim'
	Plug 'Shougo/neosnippet-snippets'
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

highlight SignifySignDelete cterm=bold ctermbg=1
highlight SignifySignAdd cterm=bold ctermbg=2
highlight SignifySignChange cterm=bold ctermbg=3

" -- plugin mappings --
" mapleader must be set BEFORE <Leader> mappings are used
let mapleader = ' '

" Editing text
" easy-align
nmap <Leader>a <Plug>(EasyAlign)
xmap <Leader>a <Plug>(EasyAlign)

" fzf
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>gq :GitQuickfix<Space>
nnoremap <Leader>l :Locate<Space>
nnoremap <Leader>m :Marks<CR>
nnoremap <Leader>n :Files <C-R>=expand('%:h')<CR><CR>
nnoremap <Leader>o :History<CR>
nnoremap <Leader>q :Quickfix<CR>
nnoremap <Leader>s :Neosnippets<CR>

" Git
" fugitive
nnoremap <Leader>gb :Git blame<CR>
xnoremap <Leader>gb :Git blame<CR>
nnoremap <Leader>gd :rightbelow Gvdiffsplit<CR>
nnoremap <Leader>ge :Gedit<CR>
nnoremap <Leader>gg :Ggrep <C-R>=expand('<cword>')<CR>
nnoremap <Leader>gl :0Gclog!<CR>
xnoremap <Leader>gl :Gclog!<CR>

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
endfunction

" Returns an expression to execute a normal mode command in a virtual column
" with a count. The returned expression can be used with a range to execute a
" normal mode command over a range at a virtual column for each line.
function! s:GetExprNormal(virtcol, count, command)
	return ':normal! '.a:virtcol.'|'.a:count.a:command."\<CR>"
endfunction

" Get visual selection
" Note that this function must be called from visual mode
function! s:GetVisualSelection()
	let l:unnamed_reg = @"
	silent normal! y
	let l:visual_selection = @"
	let @" = l:unnamed_reg
	return l:visual_selection
endfunction

" Get visual selection from normal
function! s:GetVisualSelectionFromNormal()
	normal! gv
	return <SID>GetVisualSelection()
endfunction

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

" fzf
" Git quickfix
function! s:GitQuickfix(command_string, bang)
	" Don't jump to the first error when a:bang is TRUE
	execute printf('%s system(%s)', a:bang ? 'cgetexpr' : 'cexpr', shellescape(printf('git quickfix %s', a:command_string)))
endfunction

" Quickfix
function! s:QuickfixToFzfEntry(key, val)
	let l:file = expand('#'.a:val.bufnr)
	return printf('%2d', a:key).' '.l:file.':'.a:val.lnum.':'.a:val.col.':'.a:val.text
endfunction

function! s:CcToFirstFzfEntry(fzf_entries)
	" Assume the fzf entry is reasonably well-formed with a leading error
	" number and just convert it to a number.
	let l:QuickfixErrorToErrorNumber = {_, val -> str2nr(val)}
	let l:error_numbers = map(a:fzf_entries, l:QuickfixErrorToErrorNumber)
	if !empty(l:error_numbers)
		execute 'cc' (l:error_numbers[0] + 1)
	endif
endfunction

function! s:QuickfixGetSourceSinklist()
	return {'source': map(getqflist(), function('<SID>QuickfixToFzfEntry')), 'sinklist': function('<SID>CcToFirstFzfEntry')}
endfunction

function! s:QuickfixGetWithPreview()
	" Note that fzf fields include the trailing delimiter so matching the
	" entire field and the trailing delimiter is the same as matching just the
	" trailing delimiter.
	return fzf#vim#with_preview({'options': ['--delimiter', '^\s*\d+\s+|:', '--preview-window', '+{3}-/2', '--prompt', 'Quickfix> '], 'placeholder': '{2..}'})
endfunction

" neosnippet
function! s:InsertNeosnippet(snippet_name)
	call feedkeys("i\<C-R>=neosnippet#expand('".substitute(a:snippet_name, "'", "''", 'g')."')\<CR>")
endfunction

function! s:NeosnippetsGetSourceSink()
	return {'source': keys(neosnippet#helpers#get_snippets()), 'sink': function('<SID>InsertNeosnippet')}
endfunction

function! s:NeosnippetsGetOptions(query)
	return {'options': ['--prompt', 'Snippets> ', '--query', a:query]}
endfunction

" Restore cursor
" See :h restore-cursor
function! s:RestoreCursor()
	if line("'\"") >= 1 && line("'\"") <= line('$')
		if &filetype !~# 'commit'
			normal! g`"
		endif
	endif
endfunction

" -- commands --
" fzf
" Git quickfix
command! -bang -nargs=1 GitQuickfix call <SID>GitQuickfix(<q-args>, <bang>0)

" Quickfix
command! -bang Quickfix call fzf#run(fzf#wrap(extend(<SID>QuickfixGetSourceSinklist(), <SID>QuickfixGetWithPreview()), <bang>0))

" neosnippet
command! -bang -nargs=* Neosnippets call fzf#run(fzf#wrap(extend(<SID>NeosnippetsGetSourceSink(), <SID>NeosnippetsGetOptions(<q-args>)), <bang>0))

" -- mappings --
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
xnoremap <silent> <expr> Q <SID>GetExprNormal(virtcol('.'), v:count1, '@@')

" Repeat last change on visual selection
xnoremap <silent> <expr> . <SID>GetExprNormal(virtcol('.'), v:count ? v:count : '', '.')

" Run visual selection as a command
xnoremap <silent> <Leader>r :<C-U>echo system(<SID>GetVisualSelectionFromNormal())<CR>

" Run visual selection as a command and and insert its standard output below
" the cursor.
xnoremap <silent> <Leader>R :<C-U>read !<C-R>=substitute(<SID>GetVisualSelectionFromNormal(), '\n', ';', 'g')<CR><CR>

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

if exists(':terminal')
	tnoremap <Esc><Esc> <C-\><C-N>
	if !has('nvim')
		nnoremap <Leader>t :terminal<CR>
	else
		nnoremap <Leader>t :split <Bar> terminal<CR>
	endif
endif

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
nnoremap <Leader>/ :match Search /<C-R>=@/<CR>/<CR>

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

" Workaround for poor Neovim undercurl/underline support
if has('nvim')
	augroup SpellBadGroup
		autocmd!
		autocmd ColorScheme * highlight SpellBad guibg=Red
		autocmd ColorScheme * highlight SpellCap guibg=Blue
	augroup END
endif

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
let &statusline = ' %<%f [%{(&fileencoding != "" ? &fileencoding : &encoding)}] %y%m%r %{(exists("g:loaded_fugitive") ? FugitiveStatusline() : "")} %= %-3b %-4(0x%B%) %-12(%5(%l,%)%c%V%) %P '
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
	if !empty(glob($HOME.'/.vimrc.local'))
		source $HOME/.vimrc.local
	endif
else
	if !empty(glob($VIMFILES.'/local.init.vim'))
		source $VIMFILES/local.init.vim
	endif
endif
