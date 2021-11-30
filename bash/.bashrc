# -- Important --
# Do nothing if not running interactively
if [[ $- != *i* ]]; then
	return
fi

# -- Environment --
export EDITOR='nvim'
export VISUAL='nvim'
SUDO_EDITOR="$(command -v nvim)"
export SUDO_EDITOR

export FZF_DEFAULT_OPTS='--height=40% --layout=reverse'

export LESS='--ignore-case --LONG-PROMPT --no-init --quit-if-one-screen --RAW-CONTROL-CHARS'

# Set title if running in a GUI terminal emulator
if [[ $TERM != 'console' ]] && [[ $TERM != 'linux' ]]; then
	PROMPT_COMMAND='echo -en "\e]0;$TERM $SHELL$([[ $SHLVL > 1 ]] && echo -en " [$SHLVL]") $PWD\a"'
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
export HISTSIZE=10000

# -- Aliases --
alias vim='$EDITOR'

alias cp='cp --interactive'
alias mv='mv --interactive'
alias rm='rm --interactive=once'

alias grep='grep --color=auto'

alias mkdir='mkdir --parents --verbose'

# ls aliases
alias ls='ls --color=auto'
alias la='ls --almost-all'
alias ll='la --classify --format=long --human-readable'

# xxd aliases
alias binxxd='xxd --cols 1 --bits'
alias cxxd='xxd --cols 1 --include'
alias hexxd='xxd --cols 1 --plain'
alias texxd='xxd --plain --revert'

# Open grep matches in Vim
alias vrep='qfvim rg --vimgrep'

# Alias to edit the clipboard
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

	watch --interval 0.25 --precise "TZ='UTC' date --date=\"now - ${start}\" \"+%H:%M:%S.%N\""

	TZ='UTC' date --date="now - ${start}" "+%H:%M:%S.%N"
}

# Bookmark
# Make bookmark
mkb() {
	if [ ! -d "$@" ]; then
		echo "mkb: failed to make bookmark '$@': No such file or directory" 1>&2

		return 1
	fi

	realpath --canonicalize-existing --no-symlinks "$@" >> "$HOME/bookmarks"
}

# Change directory to bookmark
cdb() {
	if [ ! -f "$HOME/bookmarks" ]; then
		echo "cb: no bookmarks available" 1>&2

		return 1
	fi

	cd "$(cat "$HOME/bookmarks" | fzf --preview='ls {}' --query="$@")"
}

# Repeat
repeat() {
	local count="$1"

	shift

	for i in $(seq 1 "$count"); do
		echo -n "$@"
	done
}

# Pre
pre() {
	cat - | sed --expression="s/^/$*/g"
}

# Post
post() {
	cat - | sed --expression="s/$/$*/g"
}

# -- Various --
# Source local bashrc if it exists
if [[ -f "$HOME/.bashrc.local" ]]; then
	source "$HOME/.bashrc.local"
fi
