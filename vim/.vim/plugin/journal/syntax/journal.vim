if exists('b:current_syntax')
	finish
endif

highlight JournalDone     ctermfg=DarkGray   guifg=DarkGray
highlight JournalCanceled ctermfg=Red        guifg=Red
highlight JournalEvent    ctermfg=Cyan       guifg=Cyan
highlight JournalMoved    ctermfg=DarkGray   guifg=DarkGray
highlight JournalNote     ctermfg=Yellow     guifg=Yellow
highlight JournalTask     ctermfg=LightGreen guifg=LightGreen
highlight JournalWeek     ctermfg=Magenta    guifg=Magenta

syntax match JournalDone     /^✓ .*$/
syntax match JournalCanceled /^❎ .*$/
syntax match JournalEvent    /^📅 .*$/
syntax match JournalMoved    /^> .*$/
syntax match JournalNote     /^📓 .*$/
syntax match JournalTask     /^◻ .*$/
syntax match JournalWeek     /^# week \d\+$/

let b:current_syntax = 'journal'
