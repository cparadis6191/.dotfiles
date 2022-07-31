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
xnoremap * /<C-R>=<SID>EscapeSearch(visual_selection#get())<CR><CR>
xnoremap # ?<C-R>=<SID>EscapeSearch(visual_selection#get())<CR><CR>

" Only whole keywords are searched for
xnoremap g* /<C-R>=<SID>WordSearch(<SID>EscapeSearch(visual_selection#get()))<CR><CR>
xnoremap g# ?<C-R>=<SID>WordSearch(<SID>EscapeSearch(visual_selection#get()))<CR><CR>

" Append search mappings
" Only whole keywords are searched for
nnoremap <Leader>* /<C-R>=<SID>AppendSearch(<SID>WordSearch(expand('<cword>')))<CR><CR>
nnoremap <Leader># ?<C-R>=<SID>AppendSearch(<SID>WordSearch(expand('<cword>')))<CR><CR>

" This makes the search also find matches that are not a whole word
nnoremap <Leader>g* /<C-R>=<SID>AppendSearch(expand('<cword>'))<CR><CR>
nnoremap <Leader>g# ?<C-R>=<SID>AppendSearch(expand('<cword>'))<CR><CR>

" This makes the search also find matches that are not a whole word
xnoremap <Leader>* /<C-R>=<SID>AppendSearch(<SID>EscapeSearch(visual_selection#get()))<CR><CR>
xnoremap <Leader># ?<C-R>=<SID>AppendSearch(<SID>EscapeSearch(visual_selection#get()))<CR><CR>

" Only whole keywords are searched for
xnoremap <Leader>g* /<C-R>=<SID>AppendSearch(<SID>WordSearch(<SID>EscapeSearch(visual_selection#get())))<CR><CR>
xnoremap <Leader>g# ?<C-R>=<SID>AppendSearch(<SID>WordSearch(<SID>EscapeSearch(visual_selection#get())))<CR><CR>
