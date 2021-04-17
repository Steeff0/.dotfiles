#DOTFILES
# Source global definitions
if [ -f /etc/bashrc ]; then
    source /etc/bashrc
elif [ -f /etc/bash.bashrc ]; then
	source /etc/bash.bashrc
fi

# Check that we haven't already been sourced.
([[ -z ${DOTFILES_BASHRC} ]] && DOTFILES_BASHRC="1") || return

# If not running interactively, don't do anything
[ -z "$PS1" ] && return
echo "Start loading bash defaults"

# Export localization variables
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Set terminal title through xterm control sequence
echo -ne "\e]0;$(hostname)\a"

#Customize prompt
[ -f ~/.dotfiles/.bash_prompt ] && source ~/.dotfiles/.bash_prompt

# Various
alias ll='ls -alh --color=auto'
alias ls='ls --color=auto'
alias mkdir='mkdir -p'
alias cl='clear'
alias h='history'
alias less='less -r'
alias kc='kubectrl'

# List bash aliases
la() {
    # Currently all my aliases are in .bashrc
    grep "^alias" ~/.bashrc  | cut -c 7- | sort
}

# History
history -a
shopt -s histappend
export HISTSIZE=100000
export HISTFILESIZE=1000000
export HISTCONTROL=ignorespace:erasedups
export HISTIGNORE='ls:history:ll:pwd'
export HISTTIMEFORMAT='%d-%m-%Y %T '
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Enable bash completion in interactive shells
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    source /etc/bash_completion
fi

# Source fzf.bash for fuzzy search
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Source all functions from bash_functions.d
for f in ~/.dotfiles/bash_functions.d/*; do
    source $f;
done

# Source local definitions.
[ -f ~/.bashrc_local ] && source ~/.bashrc_local
