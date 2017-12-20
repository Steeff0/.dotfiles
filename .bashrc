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

#Customize prompt
promptCommand() {

    #COLOR CODES
    local GREEN="\[\033[0;32m\]"
    local CYAN="\[\033[0;36m\]"
    local BCYAN="\[\033[1;36m\]"
    local BLUE="\[\033[0;34m\]"
    local GRAY="\[\033[0;37m\]"
    local DKGRAY="\[\033[1;30m\]"
    local WHITE="\[\033[1;37m\]"
    local RED="\[\033[0;31m\]"
    # return color to Terminal setting for text color
    local DEFAULT="\[\033[0;39m\]"

    # SET BRANCH
    local BRANCH=""
    # if we're in a Git repo, show current branch
    local GIT_BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    if [ ! -z ${GIT_BRANCH} ]; then
        BRANCH=${GIT_BRANCH}
    elif [ -d ".svn" ]; then
        BRANCH="[ "`svn info | awk '/Last\ Changed\ Rev/ {print $4}'`" ]"
    fi
    #Show feature and other specific branches in green. Main branches in red.
    if [[ ! -z ${BRANCH} ]] && [[ "${BRANCH}" == *"/"* ]]; then
        BRANCH="${GREEN}[${BRANCH}]${WHITE} || "
    elif [[ ! -z ${BRANCH} ]]; then
        BRANCH="${RED}[${BRANCH}]${WHITE} || "
    fi

    # SET TIME
    local TIME=`date +"%H:%M:%S"`
    
    # SET CURRENT PATH
    local CURRENT_PATH=`echo ${PWD/#$HOME/\~}`
    # trim long path
    if [ ${#CURRENT_PATH} -gt "35" ]; then
        CURRENT_PATH=".../${PWD#${PWD%/*/*/*}/}/"
    fi

    # different prompt and color for root
    local PR_COLORED="${GREEN}$"
    local USERNAME_COLORED="${GREEN}${USER}"
    if [ "$UID" = "0" ]; then
        PR_COLORED="${RED}#"
        USERNAME_COLORED="${RED}${USER}$"
    fi

    local TOP_LINE="${CYAN}[ ${GRAY}${TIME} ${WHITE}|| ${BRANCH}${GRAY}${CURRENT_PATH}${CYAN}]"
    local BOTTOM_LINE="${CYAN}[${USERNAME_COLORED}${WHITE}@${GRAY}${HOSTNAME}${CYAN}]${PR_COLORED}${DEFAULT} "
    export PS1="\n${TOP_LINE}\n${BOTTOM_LINE}"
}
PROMPT_COMMAND=promptCommand

# List bash aliases
la() {
    # Currently all my aliases are in .bashrc
    grep "^alias" ~/.bashrc  | cut -c 7- | sort
}
