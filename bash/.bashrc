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
export DEFAULT_TODO_DIR="$HOME/todos"

export FZF_DEFAULT_COMMAND='fdfind --color=always --exclude=.git --hidden --strip-cwd-prefix --type=file'
export FZF_DEFAULT_OPTS='--ansi --height=40% --layout=reverse'
export FZF_ALT_C_COMMAND='fdfind --color=always --exclude=.git --hidden --strip-cwd-prefix --type=directory'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export LESS='--ignore-case --LONG-PROMPT --no-init --quit-if-one-screen --RAW-CONTROL-CHARS'

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
if command -v batcat > /dev/null 2>&1; then
	alias cat='batcat'
fi

alias vim='$EDITOR'

alias cp='cp --interactive'
alias mv='mv --interactive'
alias rm='rm --interactive=once'

alias grep='grep --color=auto'

alias mkdir='mkdir --parents --verbose'

# ls
alias ls='ls --color=auto'
alias la='ls --almost-all'
alias ll='la --classify --format=long --human-readable'

# xxd
alias binxxd='xxd --cols 1 --bits'
alias cxxd='xxd --cols 1 --include'
alias hexxd='xxd --cols 1 --plain'
alias texxd='xxd --plain --revert'

# Edit grep matches
alias vrep='qfvim rg --vimgrep'

# Edit the clipboard
alias yedit='yoink | vipe | yeet'

# -- Umask --

# -- Functions --
# Open a new instance of bash, run a command, and do not exit
bash_remain() {
	bash --rcfile <(cat "$HOME/.bashrc" <(echo "$@"))
}

# Calculator
calc() {
	python3 -c "from math import *; print($*)"
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

# Pre
pre() {
	cat - | sed --expression="s/^/$*/g"
}

# Post
post() {
	cat - | sed --expression="s/$/$*/g"
}

# Note
note() {
	local local_note_dir="${NOTE_DIR:-$DEFAULT_NOTE_DIR}"

	if [[ $# -gt 1 ]]; then
		if [[ -z $local_note_dir ]]; then
			local_note_dir="$1"
		else
			local_note_dir="$local_note_dir/$1"
		fi

		shift
	fi

	NOTE_DIR="$local_note_dir" vim -c "Note $*"
}

# Sticky note
snote() {
	NOTE_DIR=. note "$@"
}

# Notes
notes() {
	local notes

	local local_note_dir="${NOTE_DIR:-$DEFAULT_NOTE_DIR}"

	if ! notes="$(rg --files --sortr=modified "$local_note_dir" | rg "\.md$" | fzf --delimiter="$local_note_dir/?" --multi --preview='cat {}' --print-query --query="$*" --with-nth=2..)"; then
		echo "${FUNCNAME[0]}: '$notes': No such note" 1>&2

		return 1
	fi

	vim $(echo "$notes" | tail --lines=+2)
}

# Todo
todo() {
	local todo_dir="${TODO_DIR:-$DEFAULT_TODO_DIR}"

	vim $(mktodos.py "$todo_dir" "${@:-0}")
}
}

# -- Various --
# Source local bashrc if it exists
if [[ -f "$HOME/.local/etc/.bashrc" ]]; then
	source "$HOME/.local/etc/.bashrc"
fi
