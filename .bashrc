# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Shell options
shopt -s globstar
shopt -s checkwinsize

# Navigation
shopt -s autocd
alias cd..='cd ..'
alias ..='cd ..'
alias .2='cd ../..'
alias .3='cd ../../../'
alias .4='cd ../../../..'

# Various
alias h='history'
alias j='jobs -l'
alias ll='ls -alh --color=auto'
alias ls='ls --color=auto'
alias mkdir='mkdir -p'
alias cl='clear'
alias sshgo='eval $(ssh-agent) && ssh-add'
alias v='vim'
alias clipkey='cat ~/.ssh/id_rsa.pub > /dev/clipboard'

# History
shopt -s histappend
export HISTFILESIZE=1000000
export HISTSIZE=100000
export HISTCONTROL=ignorespace
export HISTIGNORE='ls:history:ll'
export HISTTIMEFORMAT='%d-%m-%Y %T'

# Git
# Create g<alias> shortcuts for all git aliases and enable git autocompletion
function_exists() {
    declare -f -F $1 > /dev/null
    return $?
}

for al in `__git_aliases`; do
    alias g$al="git $al"

    complete_func=_git_$(__git_aliased_command $al)
    function_exists $complete_fnc && __git_complete g$al $complete_func
done

# Customize prompt PS1
my_prompt() {
    local branch=$(git branch 2>/dev/null | grep '^*' | sed s/..//)
    local branch_addition=""

    if [ -n "$branch" ]
    then
      branch_addition=" [\[\e[38;5;202m\]${branch}\[\e[0m\]]"
    fi

    export PS1="\u@\h:\w${branch_addition}\\$ "
}

PROMPT_COMMAND=my_prompt
