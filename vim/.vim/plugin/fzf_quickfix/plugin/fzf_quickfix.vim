" fzf
" Quickfix
function! s:QuickfixToFzfEntry(key, val)
	let l:file = expand('#'.a:val.bufnr)
	let l:shortened_file_path = pathshorten(l:file)
	let l:error_number = printf('%2d', a:key)
	return [l:error_number, ' ', l:shortened_file_path, ':', l:file, ':', a:val.lnum, ':', a:val.col, ':', a:val.text]
endfunction

function! s:CcToFirstFzfEntry(fzf_entries)
	if !empty(a:fzf_entries)
		" Assume the fzf entry is reasonably well-formed with a leading error
		" number and just convert it to a number.
		let l:error_number = str2nr(a:fzf_entries[0]) + 1
		execute 'cc' l:error_number
	endif
endfunction

function! s:QuickfixGetSourceSinklist()
	let l:fzf_entries = map(getqflist(), function('<SID>QuickfixToFzfEntry'))
	let l:fzf_entry_strings = map(l:fzf_entries, {_, val -> join(val, '')})
	return {'source': l:fzf_entry_strings, 'sinklist': function('<SID>CcToFirstFzfEntry')}
endfunction

function! s:QuickfixGetWithPreview()
	" Note that fzf fields include the trailing delimiter so matching the
	" entire field and the trailing delimiter is the same as matching just the
	" trailing delimiter.
	return fzf#vim#with_preview({'options': ['--delimiter', '^\s*\d+\s+|:', '--preview-window', '+{4}-/2', '--prompt', 'Quickfix> ', '--with-nth', '{..2,4..5}'], 'placeholder': '{3..}'})
endfunction

" Quickfix files
function! s:FzfEntryToFile(fzf_entry)
	return a:fzf_entry[4]
endfunction

function! s:QuickfixFilesGetSourceSink()
	let l:fzf_entries = map(getqflist(), function('<SID>QuickfixToFzfEntry'))
	let l:uniq_fzf_entry_list = uniq(l:fzf_entries, {i1, i2 -> <SID>FzfEntryToFile(i1) != <SID>FzfEntryToFile(i2)})
	let l:uniq_fzf_entry_strings = map(l:uniq_fzf_entry_list, {_, val -> join(val, '')})
	return {'source': l:uniq_fzf_entry_strings, 'sinklist': function('<SID>CcToFirstFzfEntry')}
endfunction

" Quickfix
command! -bang Quickfix call fzf#run(fzf#wrap(extend(<SID>QuickfixGetSourceSinklist(), <SID>QuickfixGetWithPreview()), <bang>0))

" Quickfix files
command! -bang QuickfixFiles call fzf#run(fzf#wrap(extend(<SID>QuickfixFilesGetSourceSink(), <SID>QuickfixGetWithPreview()), <bang>0))

nnoremap <Leader>q :Quickfix<CR>
nnoremap <Leader>Q :QuickfixFiles<CR>
