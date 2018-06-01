# If not running interactively do nothing
if [[ "$-" != *i* ]]; then
	return
fi

# -- Shell Options --
PS1='\[\033[32m\]\u\[\033[m\]\[\033[34m\]@\[\033[m\]\[\033[35m\]\h\[\033[m\] \[\033[33m\]\W\[\033[m\]\\$ '
PS2='  > '

# Set window title if running in nice GUI terminal emulator
if [[ "$TERM" != 'linux' ]] && [[ "$TERM" != 'console' ]]; then
	PROMPT_COMMAND='echo -ne "\033]0;$TERM $SHELL $PWD\007"'
fi

shopt -s checkwinsize
shopt -s globstar
shopt -s histappend

# -- Completion options --

# -- History Options --
HISTSIZE=10000

# -- Aliases --
export EDITOR='nvim'
export VISUAL='$EDITOR'
alias vim='$EDITOR'

alias rm='rm --interactive=once'
alias cp='cp --interactive'
alias mv='mv --interactive'

alias mkdir='mkdir --parents --verbose'

alias grep='grep --color=auto'

alias ls='ls --color=auto'
alias la='ls --almost-all'
alias ll='la --classify --human-readable -l'
alias lt='ll --sort=time'

alias less='less --prompt="?f%f .?n?m(%T %i of %m) ..?ltlines %lt-%lb?L/%L. :byte %bB?s/%s. .?e(END) ?x- Next\: %x.:?pB%pB\%..%t"'

# -- Umask --
# -- Functions --

# -- Local Environment --
if [[ -f "$HOME/.local.bashrc" ]]; then
	source "$HOME/.local.bashrc"
fi
