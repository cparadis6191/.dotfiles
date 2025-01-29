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

export DEFAULT_NOTE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/notes"
export DEFAULT_JOURNAL_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/journals"

export FZF_DEFAULT_COMMAND='fd --color=always --exclude=.git --hidden --strip-cwd-prefix --type=file'
export FZF_DEFAULT_OPTS='--ansi --height=40% --layout=reverse'
export FZF_ALT_C_COMMAND='fd --color=always --exclude=.git --hidden --strip-cwd-prefix --type=directory'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export LESS='--ignore-case --LONG-PROMPT --mouse --no-init --RAW-CONTROL-CHARS --wheel-lines=3'

if command -v batcat > /dev/null 2>&1; then
	export MANROFFOPT='-c'
	export MANPAGER='sh -c "col --no-backspaces --spaces | batcat --language man --plain"'
fi

# Set title if running in a GUI terminal emulator
if [[ $TERM != 'console' ]] && [[ $TERM != 'linux' ]]; then
	PROMPT_COMMAND='echo -en "\e]0;$([[ -n $SSH_CONNECTION ]] && echo -en "ssh ")$TERM $SHELL$([[ $SHLVL > 1 ]] && echo -en " [$SHLVL]") $PWD\a"'
fi

# Set primary prompt
PS1='\[\e[32m\]\u\[\e[34m\]@\[\e[35m\]\h \[\e[33m\]\W\[\e[31m\]$([[ \j > 0 ]] && echo -en " &\j")\[\e[0m\]\$ '

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
fi
if command -v bat > /dev/null 2>&1; then
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
else
	alias ls='ls --color=auto'
fi

# mkdir
alias mkdir='mkdir --parents --verbose'

# mv
alias mv='mv --interactive'

# rm
alias rm='rm --interactive=once'

# -- Umask --

# -- Functions --
# Open a new instance of bash, run a command, and do not exit
bash_remain() {
	bash --rcfile <(cat "$HOME/.bashrc" <(echo "$@"))
}

# Change directory to bookmark
cdb() {
	cd -- "$(cdb-impl "$@")" || return 1
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

# -- Various --
# Source local bashrc if it exists
if [[ -f "$HOME/.local/etc/.bashrc" ]]; then
	source "$HOME/.local/etc/.bashrc"
fi
