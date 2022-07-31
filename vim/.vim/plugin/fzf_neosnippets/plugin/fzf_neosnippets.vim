" fzf
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

" neosnippet
command! -bang -nargs=* Neosnippets call fzf#run(fzf#wrap(extend(<SID>NeosnippetsGetSourceSink(), <SID>NeosnippetsGetOptions(<q-args>)), <bang>0))

nnoremap <Leader>s :Neosnippets<CR>
