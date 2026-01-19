" fzf
" neosnippet
function! s:InsertNeosnippet(fzf_entry)
	let l:snippet_name = split(a:fzf_entry, '\V[[:delim:]]')[0]
	call feedkeys("i\<C-R>=neosnippet#expand('".substitute(l:snippet_name, "'", "''", 'g')."')\<CR>")
endfunction

function! s:NeosnippetsToFzfEntry(key, val)
	return [a:key, '[[:delim:]]', a:val.action__path, '[[:delim:]]', a:val.action__line)]
endfunction

function! s:NeosnippetsGetSourceSink()
	let l:fzf_entries = values(map(neosnippet#helpers#get_snippets(), function('<SID>NeosnippetsToFzfEntry')))
	let l:fzf_entry_strings = map(l:fzf_entries, {_, val -> join(val, '')})
	return {'source': l:fzf_entry_strings, 'sink': function('<SID>InsertNeosnippet')}
endfunction

function! s:NeosnippetsGetOptionsWithPreview(query)
	return fzf#vim#with_preview({'options': ['--delimiter', '[[:delim:]]', '--preview-window', '+{3}', '--with-nth', '{1}', '--prompt', 'Snippets> ', '--query', a:query], 'placeholder': '{2}:{3}'})
endfunction

" neosnippet
command! -bang -nargs=* Neosnippets call fzf#run(fzf#wrap(extend(<SID>NeosnippetsGetSourceSink(), <SID>NeosnippetsGetOptionsWithPreview(<q-args>)), <bang>0))

nnoremap <Leader>s :Neosnippets<CR>
