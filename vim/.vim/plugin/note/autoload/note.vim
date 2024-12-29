" Note
function! note#note(bang, ...)
	let l:note_dir=(!empty($NOTE_DIR) ? $NOTE_DIR : $DEFAULT_NOTE_DIR)
	if !empty(l:note_dir) && l:note_dir[-1:] != '/'
		let l:note_dir=l:note_dir.'/'
	endif
	if empty(glob(l:note_dir))
		call mkdir(l:note_dir, 'p')
	endif
	let l:note_file='note-'.strftime('%Y-%m-%d')
	if len(a:000)
		let l:note_file=l:note_file.'-'.join(a:000)
	endif
	let l:note_file=l:note_file.'.md'
	execute (a:bang ? 'edit!' : 'edit') fnameescape(l:note_dir.l:note_file)
endfunction
