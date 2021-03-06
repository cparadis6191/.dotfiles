# -- Important --
# Do nothing if not running interactively
if [[ $- != *i* ]]; then
	return
fi

# -- Environment --
export EDITOR='nvim'
export VISUAL='nvim'
export SUDO_EDITOR="$(which nvim)"

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

# -- Umask --

# -- Functions --
# Open a new instance of bash, run a command, and do not exit
bash_remain() {
	bash --rcfile <(cat "$HOME/.bashrc" <(echo "$@"))
}

# Open grep matches in Vim
vrep() {
	qfvim rg --vimgrep "$@"
}

# Edit the clipboard
yedit() {
	yoink | vipe | yeet
}

# Calculator
calc() {
	python3 -c "from math import *; print($*)"
}

# -- Various --
# Source local bashrc if it exists
if [[ -f "$HOME/.bashrc.local" ]]; then
	source "$HOME/.bashrc.local"
fi
