if exists('b:current_syntax')
	finish
endif

set filetype=markdown.journal

highlight JournalDone     ctermfg=DarkGray   guifg=DarkGray
highlight JournalCanceled ctermfg=Red        guifg=Red
highlight JournalEvent    ctermfg=Cyan       guifg=Cyan
highlight JournalMoved    ctermfg=DarkGray   guifg=DarkGray
highlight JournalNote     ctermfg=Yellow     guifg=Yellow
highlight JournalTask     ctermfg=Green      guifg=Green
highlight JournalToday    ctermfg=Magenta    guifg=Magenta
highlight JournalTomorrow ctermfg=Magenta    guifg=Magenta
highlight JournalWeek     ctermfg=Magenta    guifg=Magenta

syntax match JournalDone     /^* ✓ .*$/       contains=JournalNote
syntax match JournalCanceled /^* ❎ .*$/      contains=JournalNote
syntax match JournalEvent    /^* 📅 .*$/      contains=JournalNote
syntax match JournalMoved    /^* > .*$/       contains=JournalNote
syntax match JournalNote     /📓 .*$/
syntax match JournalTask     /^* ◻ .*$/       contains=JournalNote
syntax match JournalToday    /^## today/      contains=JournalNote
syntax match JournalTomorrow /^## tomorrow/   contains=JournalNote
syntax match JournalWeek     /^## week \d\+$/ contains=JournalNote

let b:current_syntax = 'journal'
