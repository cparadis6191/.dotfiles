" Returns an expression to execute a normal mode command in a virtual column
" with a count. The returned expression can be used with a range to execute a
" normal mode command over a range at a virtual column for each line.
function! s:GetNormalExpr(virtcol, count, command)
	return ':normal! '.a:virtcol.'|'.a:count.a:command."\<CR>"
endfunction

xnoremap <silent> <expr> Q <SID>GetNormalExpr(virtcol('.'), v:count1, '@@')

" Repeat last change on visual selection
xnoremap <silent> <expr> . <SID>GetNormalExpr(virtcol('.'), v:count ? v:count : '', '.')
