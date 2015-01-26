# .bashrc - Save this file as .bashrc in your home directory. (e.g. /home/user/.bashrc)
# Author: Chad Paradis


# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# -- Shell Options --
# See man bash for more options...
PS1="\[\e[32m\]\u\[\e[m\]\[\e[34m\]@\[\e[m\]\[\e[35m\]\h\[\e[m\] \[\e[33m\]\W\[\e[m\]\\$ "    # Custom colorful bash prompt
PS2="$PS1  > "    # Another custom prompt if a quote isn't closed

PROMPT_COMMAND='echo -ne "\033]0;$PWD\007"'

shopt -s checkwinsize    # Updates the window if its size changes
shopt -s autocd          # change directory if just inputting a directory name

# -- Completion options --

# -- History Options --
HISTSIZE=9999

# -- Aliases --
alias rm='rm -I'    # Interactive operation
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'

alias grep='grep --color=auto'    # Show differences in colour
alias egrep='grep -e'             # Extended regexp support

# Some shortcuts for different directory listings
alias ls='ls -h --color=auto'     # Classify files in colour
alias la='ls -A'                  # All but . and ..
alias ll='ls -lA'                 # Long list
alias lt='ls -Lt'                 # Long list sorted by time

alias indent='indent -linux -br -brf -brs'

alias vim='vim -p'                # Make vim open with tabs

alias less='less -P "?f%f .?n?m(%T %i of %m) ..?ltlines %lt-%lb?L/%L. :byte %bB?s/%s. .?e(END) ?x- Next\: %x.:?pB%pB\%..%t"'    # Make less display line number like systemctl

# -- Umask --
# -- Functions --

# -- Local Environment --
if [ -f ~/.bashrc.local ]; then
	source ~/.bashrc.local
fi
