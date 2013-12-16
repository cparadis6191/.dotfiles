# .bashrc - Save this file as .bashrc in your home directory. (e.g. /home/user/.bashrc)
# Author: Chad Paradis


# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# -- Shell Options --
# See man bash for more options...
PS1="\[\e[32m\]\u@\h \[\e[33m\]\W\[\e[33m\]\[\e[0m\]\$ "    # Custom colorful bash prompt

# Updates the window if its size changes
shopt -s checkwinsize

# -- Completion options --

# -- History Options --
HISTSIZE=10000

# -- Aliases --

# Interactive operation...
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias grep='grep --color=auto'          # Show differences in colour
alias egrep='grep -e'                   # Extended regexp support

# Some shortcuts for different directory listings
alias ls='ls -h --color=auto'           # Classify files in colour
alias la='ls -A'                        # All but . and ..
alias ll='ls -lA'                       # Long list
alias lt='ls -Lt'                       # Long list sorted by time

alias vim='vim -p'                      # Make vim open with tabs

alias less='less -P "line %lb of %L"'   # Make less display line number

# -- Umask --
# -- Functions --
