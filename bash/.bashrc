# -- Important --
# Do nothing if not running interactively
case $- in
	*i*) ;;
	*) return ;;
esac

# -- Environment --
export EDITOR='nvim'
export VISUAL="$EDITOR"
SUDO_EDITOR="$(command -v "$EDITOR")"
export SUDO_EDITOR

export DEFAULT_NOTE_DIR="$HOME/notes"
export DEFAULT_JOURNAL_DIR="$HOME/journals"

export FZF_DEFAULT_COMMAND='fdfind --color=always --exclude=.git --hidden --strip-cwd-prefix --type=file'
export FZF_DEFAULT_OPTS='--ansi --height=40% --layout=reverse'
export FZF_ALT_C_COMMAND='fdfind --color=always --exclude=.git --hidden --strip-cwd-prefix --type=directory'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export LESS='--ignore-case --LONG-PROMPT --no-init --RAW-CONTROL-CHARS'

if command -v batcat > /dev/null 2>&1; then
	export MANPAGER='sh -c "col --no-backspaces --spaces | batcat --language man --plain"'
fi

# Set title if running in a GUI terminal emulator
if [[ $TERM != 'console' ]] && [[ $TERM != 'linux' ]]; then
	PROMPT_COMMAND='echo -en "\e]0;$([[ -n $SSH_CONNECTION ]] && echo -en "ssh ")$TERM $SHELL$([[ $SHLVL > 1 ]] && echo -en " [$SHLVL]") $PWD\a"'
fi

# Set primary prompt
PS1='\[\e[32m\]\u\[\e[34m\]@\[\e[35m\]\h \[\e[33m\]\W\[\e[31m\]$([[ \j > 0 ]] && echo -en " \j")\[\e[0m\]\$ '

# Set secondary prompt
PS2='  > '

# -- Shell Options --
set -o ignoreeof

shopt -s checkwinsize
shopt -s globstar
shopt -s histappend

# -- Completion options --

# -- History options --
export HISTSIZE=100000

# -- Aliases --
# bat
if command -v batcat > /dev/null 2>&1; then
	alias bat='batcat'
	alias cat='bat --paging never'
fi

# cp
alias cp='cp --interactive'

# fd
if command -v fdfind > /dev/null 2>&1; then
	alias fd='fdfind'
fi

# grep
alias grep='grep --color=auto'

# ls
if command -v exa > /dev/null 2>&1; then
	alias ls='exa --color=auto'
	alias la='ls --all'
	alias ll='la --binary --classify --long'
else
	alias ls='ls --color=auto'
	alias la='ls --almost-all'
	alias ll='la --classify --format=long --human-readable'
fi

# mkdir
alias mkdir='mkdir --parents --verbose'

# mv
alias mv='mv --interactive'

# rm
alias rm='rm --interactive=once'

# vim
alias vim='$EDITOR'

# Edit grep matches
alias vrep='qfvim rg --vimgrep'

# xxd
alias binxxd='xxd --cols 1 --bits'
alias cxxd='xxd --cols 1 --include'
alias hexxd='xxd --cols 1 --plain'
alias texxd='xxd --plain --revert'

# -- Umask --

# -- Functions --
# Open a new instance of bash, run a command, and do not exit
bash_remain() {
	bash --rcfile <(cat "$HOME/.bashrc" <(echo "$@"))
}

# Calculator
calc() {
	python3 <(cat - << 'HEREDOC'
from math import *
from sys import argv


print(eval(" ".join(argv[1:])))
HEREDOC
	) "$*"
}

# Stopwatch
stopwatch() {
	local start
	start="$(date +%s) seconds"

	watch --interval 0.25 --precise "date --date=\"now - ${start}\" --utc '+%H:%M:%S.%N'"

	date --date="now - ${start}" --utc '+%H:%M:%S.%N'
}

# Bookmark
# Make bookmark
mkb() {
	if [[ ! -d "$*" ]]; then
		echo "${FUNCNAME[0]}: cannot create bookmark '$*': No such file or directory" 1>&2

		return 1
	fi

	realpath --canonicalize-existing --no-symlinks -- "$@" >> "$HOME/bookmarks"
}

# Change directory to bookmark
cdb() {
	if [[ ! -f "$HOME/bookmarks" ]]; then
		echo "${FUNCNAME[0]}: No bookmarks available" 1>&2

		return 1
	fi

	local bookmark

	if ! bookmark="$(fzf --preview='ls {}' --print-query --query="$*" < "$HOME/bookmarks")"; then
		echo "${FUNCNAME[0]}: '$bookmark': No such bookmark" 1>&2

		return 2
	fi

	cd -- "$(echo "$bookmark" | tail --lines=1)" || return 3
}

# Repeat
repeat() {
	local count="$1"

	shift

	for _ in $(seq 1 "$count"); do
		echo -n "$@"
	done

	echo
}

# Prefix
pre() {
	cat - | sed --expression="s/^/$*/g"
}

# Postfix
post() {
	cat - | sed --expression="s/$/$*/g"
}

# Note
note() {
	local note_dir="${NOTE_DIR:-$DEFAULT_NOTE_DIR}"

	if [[ $# -gt 1 ]]; then
		if [[ -z $note_dir ]]; then
			note_dir="$1"
		else
			note_dir="$note_dir/$1"
		fi

		shift
	fi

	NOTE_DIR="$note_dir" vim -c "Note $*"
}

# Sticky note
snote() {
	NOTE_DIR=. note "$@"
}

# Notes
notes() {
	local notes

	local note_dir="${NOTE_DIR:-$DEFAULT_NOTE_DIR}"

	if ! notes="$(rg --files --sortr=modified "$note_dir" |
		rg "\.md$" |
		fzf --delimiter="$note_dir/?" \
			--multi \
			--preview='cat {}' \
			--print-query \
			--query="$*" \
			--with-nth=2..)"; then
		echo "${FUNCNAME[0]}: '$notes': No such note" 1>&2

		return 1
	fi

	vim $(echo "$notes" | tail --lines=+2)
}

# Journal
journal() {
	local journal_dir="${JOURNAL_DIR:-$DEFAULT_JOURNAL_DIR}"

	vim $(mkjournals "$journal_dir" "${@:-0}")
}

journals() {
	local journals

	local journal_dir="${JOURNAL_DIR:-$DEFAULT_JOURNAL_DIR}"

	if ! journals="$(rg --files --sortr=modified "$journal_dir" |
		rg "\.journal$" |
		fzf --delimiter="$journal_dir/?" \
		    --multi \
		    --preview='cat {}' \
		    --print-query \
		    --query="$*" \
		    --with-nth=2..)"; then
		echo "${FUNCNAME[0]}: '$journals': No such journal" 1>&2

		return 1
	fi

	vim -c 'wincmd b' -O $(echo "$journals" | tail --lines=+2)
}

# -- Various --
# Source local bashrc if it exists
if [[ -f "$HOME/.local/etc/.bashrc" ]]; then
	source "$HOME/.local/etc/.bashrc"
fi
