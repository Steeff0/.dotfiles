#DOTFILES GENERATED
# If not running interactively, don't do anything
[ -z "$PS1" ] && return
echo "Start loading bash defaults"

# Source local definitions.
[ -f ~/.bashrc_local ] && source ~/.bashrc_local

# Set terminal title through xterm control sequence
echo -ne "\e]0;$(hostname)\a"

# Source global definitions
if [ -f /etc/bashrc ]; then
    source /etc/bashrc
elif [ -f /etc/bash.bashrc ]; then
	source /etc/bash.bashrc
fi

#Customize prompt
[ -f ~/.bash_ps1 ] && source ~/.bash_ps1

# Enable bash completion in interactive shells
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Source fzf.bash for fuzzy search
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Export localization variables
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Various
alias ll='ls -alh --color=auto'
alias ls='ls --color=auto'
alias mkdir='mkdir -p'
alias cl='clear'
alias h='history'
alias less='less -r'
alias d='winpty docker'
alias dc='docker-compose'
alias k='kubectrl'

# List bash aliases
la() {
    # Currently all my aliases are in .bashrc
    grep "^alias" ~/.bashrc  | cut -c 7- | sort
}

# History
history -a
shopt -s histappend
export HISTFILESIZE=1000000
export HISTSIZE=100000
export HISTCONTROL=ignorespace
export HISTIGNORE='ls:history:ll'
export HISTTIMEFORMAT='%d-%m-%Y %T '

# Userful functions
function docker-bash {
    container=$1
    if [ -z "${container}" ]; then
        echo "The 'docker-bash' command needs a container name as parameter"
    else
        winpty docker exec -it "${container}" bash
    fi
}

# Set up ssh-agent
SSH_ENV="$HOME/.ssh/environment"
function activate_agent {
    echo "Initializing new SSH agent..."
    [ -f "${SSH_ENV}" ] && rm -f $SSH_ENV
    touch $SSH_ENV
    chmod 600 "${SSH_ENV}"
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' >> "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add
}

function start_agent {
    # Source SSH settings, if applicable
    if [ -f "${SSH_ENV}" ]; then
        . "${SSH_ENV}" > /dev/null
        kill -0 $SSH_AGENT_PID 2>/dev/null || {
            activate_agent
        }
    else
        activate_agent
    fi
}
start_agent
