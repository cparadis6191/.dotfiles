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

# Set window title if running in a GUI terminal emulator
if [[ $TERM != 'console' ]] && [[ $TERM != 'linux' ]]; then
	PROMPT_COMMAND='echo -en "\e]0;$TERM $SHELL $PWD\007"'
fi

PS1='\[\e[32m\]\u\[\e[m\]\[\e[34m\]@\[\e[m\]\[\e[35m\]\h\[\e[m\] \[\e[33m\]\W\[\e[m\]\$ '
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
alias ll='ls --human-readable'
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

# Open grep matches in vim
vrep() {
	qfvim rg --vimgrep "$@"
}

# Edit the clipboard
yedit() {
	yoink | vipe | yeet
}

# -- Various --
# Source local bashrc if it exists
if [[ -f "$HOME/.bashrc.local" ]]; then
	source "$HOME/.bashrc.local"
fi
