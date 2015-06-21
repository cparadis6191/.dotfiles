# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# -- Shell Options --
# See man bash for more options...
PS1='\[\033[32m\]\u\[\033[m\]\[\033[34m\]@\[\033[m\]\[\033[35m\]\h\[\033[m\] \[\033[33m\]\W\[\033[m\]\\$ '
PS2='  > '    # Another custom prompt if a quote is not closed

# If running in a nice gui terminal emulator set the window title
if [ ! "$TERM" == 'linux' ] && [ ! "$TERM" == 'console' ]; then
	PROMPT_COMMAND='echo -ne "\033]0;$TERM $SHELL $PWD\007"'
fi

shopt -s cdable_vars     # If cd argument is not a directory it is assumed to be a variable and expanded
shopt -s cdspell         # Errors in cd will be corrected
shopt -s checkwinsize    # Updates the window if its size changes
shopt -s dirspell        # Tab corrects misspelled directories
shopt -s globstar        # Let ** be used to glob files and directories recursively and **/ for directories
shopt -s histappend      # Append to history instead of overwriting it

# -- Completion options --

# -- History Options --
HISTSIZE=9999

# -- Aliases --
export EDITOR='vim'

# Interactive operation
alias rm='rm -I'    # Prompt once before removing more than three files
alias cp='cp -i'
alias mv='mv -i'

alias mkdir='mkdir -pv'    # Make parent directories as needed

alias grep='grep --color=auto'    # Show differences in colour

# Some shortcuts for different directory listings
alias ls='ls --color=auto'    # Classify files in colour
alias la='ls -A'              # All but . and ..
alias ll='ls -Ahl'            # Long list
alias lt='ls -Ahlt'           # Long list sorted by time

alias indent='indent -linux -br -brf -brs'
alias less='less -P "?f%f .?n?m(%T %i of %m) ..?ltlines %lt-%lb?L/%L. :byte %bB?s/%s. .?e(END) ?x- Next\: %x.:?pB%pB\%..%t"'    # Make less display line number like systemctl

# -- Umask --
# -- Functions --

# -- Local Environment --
if [ -f $HOME/.bashrc.local ]; then
	source $HOME/.bashrc.local
fi
