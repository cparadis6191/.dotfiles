# -- Important --
# Do nothing if not running interactively
if [[ $- != *i* ]]; then
	return
fi

# -- Environment --
export LESS='--ignore-case --LONG-PROMPT --no-init --quit-if-one-screen --RAW-CONTROL-CHARS'

export EDITOR='nvim'
export VISUAL='nvim'

PS1='\[\033[32m\]\u\[\033[m\]\[\033[34m\]@\[\033[m\]\[\033[35m\]\h\[\033[m\] \[\033[33m\]\W\[\033[m\]\\$ '
PS2='  > '

# Set window title if running in a GUI terminal emulator
if [[ $TERM != 'console' ]] && [[ $TERM != 'linux' ]]; then
	PROMPT_COMMAND='echo -en "\033]0;$TERM $SHELL $PWD\007"'
fi

# -- Shell Options --
set -o ignoreeof

shopt -s checkwinsize
shopt -s globstar
shopt -s histappend

# -- Completion options --

# -- History options --
HISTSIZE=10000

# -- Aliases --
alias vim='$EDITOR'

alias cp='cp --interactive'
alias mv='mv --interactive'
alias rm='rm --interactive=once'

alias grep='grep --color=auto'

alias mkdir='mkdir --parents --verbose'

alias ls='ls --color=auto'
alias la='ls --almost-all'
alias ll='la --classify --human-readable -l'
alias lt='ll --sort=time'

alias binxxd='xxd --cols 1 --bits'
alias cxxd='xxd --cols 1 --include'
alias hexxd='xxd --cols 1 --plain'
alias texxd='xxd --plain --revert'

# -- Umask --

# -- Functions --
bash_remain() {
	bash --rcfile <(cat "$HOME/.bashrc" <(echo "$@"))
}

# -- Various --
if [[ -f "$HOME/.bashrc.local" ]]; then
	source "$HOME/.bashrc.local"
fi
