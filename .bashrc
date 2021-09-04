#DOTFILES
# Source global definitions
if [ -f /etc/bashrc ]; then
    source /etc/bashrc
elif [ -f /etc/bash.bashrc ]; then
	source /etc/bash.bashrc
fi

# Check that we haven't already been sourced.
([[ -z ${DOTFILES_BASHRC} ]] && DOTFILES_BASHRC="1") || return

function __get_bash_dir() {
    local BASHRC_SOURCE="${BASH_SOURCE[0]}"
    while [ -h "$BASHRC_SOURCE" ]; do # resolve $BASHRC_SOURCE until the file is no longer a symlink
      local BASHRC_DIR="$( cd -P "$( dirname "$BASHRC_SOURCE" )" && pwd )"
      local BASHRC_SOURCE="$(readlink "$BASHRC_SOURCE")"
      [[ $BASHRC_SOURCE != /* ]] && BASHRC_SOURCE="$BASHRC_DIR/$BASHRC_SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done
    echo "$( cd -P "$( dirname "$BASHRC_SOURCE" )" && pwd )"
}
DOTFILES_DIR="$(__get_bash_dir)"

# If not running interactively, don't do anything
[ -z "$PS1" ] && return
echo "Start loading bash defaults"

# Set terminal title through xterm control sequence
echo -ne "\e]0;$(hostname)\a"

#Customize prompt
[ -f ${DOTFILES_DIR}/.bash_prompt.sh ] && source ${DOTFILES_DIR}/.bash_prompt.sh

# Various
alias ll='ls -alh --color=auto'
alias ls='ls --color=auto'
alias mkdir='mkdir -p'
alias cl='clear'
alias h='history'
alias less='less -r'
alias kc='kubectl'

# List bash aliases
function la() {
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
for f in ${DOTFILES_DIR}/bash_functions.d/*; do
    source $f;
done

# Source local definitions.
[ -f ~/.bashrc_local ] && source ~/.bashrc_local

function traefik {
    command="${1}"
    if [ -z "${TRAEFIK_HOME}" ]; then
        echo "TRAEFIK_HOME variable not set."
        return 1
    fi
    if [ "${command}" == "up" ]; then
        echo "Starting traefik"
        docker-compose -f ${TRAEFIK_HOME}/docker-compose.yml up -d
    elif [ "${command}" == "down" ]; then
        echo "Stopping traefik"
        docker-compose -f ${TRAEFIK_HOME}/docker-compose.yml stop
    elif [ "${command}" == "stop" ]; then
        echo "Stopping traefik"
        docker-compose -f ${TRAEFIK_HOME}/docker-compose.yml stop
    elif [ "${command}" == "restart" ]; then
        echo "Restarting traefik"
        docker-compose -f ${TRAEFIK_HOME}/docker-compose.yml restart
    elif [ "${command}" == "status" ]; then
        if [ ! -z $(docker ps -qf name=traefik) ]; then
            echo "Traefik status: UP"
        else
            echo "Traefik status: DOWN"
        fi
    else
        echo """
The traefik command can be used by using 'traefik <command>'. The command options are:

    up:         Starts the traefik container
    down/stop:  Stop the traefik container
    restart:    Restarts the traefik container
    status:     Shows the status of the traefik container
        """
    fi
}
