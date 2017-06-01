# Source local definitions.
if [ -f ~/.bashrc.local ]; then
  . ~/.bashrc.local
fi

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Set terminal title through xterm control sequence
echo -ne "\e]0;$(hostname)\a"

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Enable bash completion in interactive shells
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Source fzf.bash for fuzzy search
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Export localization variables
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Shell options
shopt -s globstar
shopt -s checkwinsize

# Various
alias ll='ls -alh --color=auto'
alias ls='ls --color=auto'
alias mkdir='mkdir -p'
alias cl='clear'
alias sshgo='eval $(ssh-agent) && ssh-add'
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias less='less -r'

# History
history -a
shopt -s histappend
export HISTFILESIZE=1000000
export HISTSIZE=100000
export HISTCONTROL=ignorespace
export HISTIGNORE='ls:history:ll'
export HISTTIMEFORMAT='%d-%m-%Y %T '

# Customize prompt PS1
my_prompt() {
  # get current branch in git repo
  function parse_git_branch() {
    BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    if [ ! "${BRANCH}" == "" ]
    then
      echo "[${BRANCH}]"
    else
      echo ""
    fi
  }

  export PS1="[\[\e[32m\]\u\[\e[m\]\[\e[32m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\]:\w]\[\e[31m\]\`parse_git_branch\`\[\e[m\]\\$ "
}
PROMPT_COMMAND=my_prompt

# List bash aliases
la() {
    # Currently all my aliases are in .bashrc
    grep "^alias" ~/.bashrc  | cut -c 7- | sort
}

# Generate a random password
randpasswd() {
    tr -dc a-zA-Z0-9 < /dev/urandom | head -c${1:-32}; echo 1>&2;
}
