# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Enable bash completion in interactive shells
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Export localization variables
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

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
alias -- -="cd -"

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
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"

# History
history -a
shopt -s histappend
export HISTFILESIZE=1000000
export HISTSIZE=100000
export HISTCONTROL=ignorespace
export HISTIGNORE='ls:history:ll'
export HISTTIMEFORMAT='%d-%m-%Y %T '

# Git
# Create g<alias> shortcuts for all git aliases and enable git autocompletion
function_exists() {
    declare -f -F $1 > /dev/null
    return $?
}

for al in `__git_aliases`; do
    alias g$al="git $al"

    complete_func=_git_$(__git_aliased_command $al)
    function_exists $complete_func && __git_complete g$al $complete_func
done

# Create a new directory and enter it
function mkd() {
    mkdir -p "$@" && cd "$_";
}

# Customize prompt PS1
my_prompt() {
    local branch=$(git branch 2>/dev/null | grep '^*' | sed s/..//)
    local branch_addition=""

    if [ -n "$branch" ]
    then
      branch_addition=" [\[\e[38;5;202m\]${branch}\[\e[0m\]]"
    fi

    export PS1="\u@\h:\[\e[38;5;57m\]\w\[\e[0m\]${branch_addition} \\$ "
}

PROMPT_COMMAND=my_prompt

# List bash aliases
la() {
    # Currently all my aliases are in .bashrc
    grep "^alias" ~/.bashrc  | cut -c 7- | sort
}
