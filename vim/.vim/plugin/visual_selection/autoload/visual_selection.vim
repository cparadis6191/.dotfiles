" Get visual selection
" Note that this function must be called from visual mode
function! visual_selection#get()
	let l:unnamed_reg = @"
	silent normal! y
	let l:visual_selection = @"
	let @" = l:unnamed_reg
	return l:visual_selection
endfunction

" Get visual selection from normal
function! visual_selection#get_from_normal()
	normal! gv
	return visual_selection#get()
endfunction
