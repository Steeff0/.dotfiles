#!/bin/bash

#Proxy stuff
export NODE_TLS_REJECT_UNAUTHORIZED=0

# Various
alias ll='ls -alh --color=auto'
alias ls='ls --color=auto'
alias mkdir='mkdir -p'
alias cl='clear'
alias h='history'
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
export HISTTIMEFORMAT='%d-%m-%Y %T'

function go {
	location=$1
	if [ -z "${location}" ]; then
		echo "The command go needs a location"
	elif [ "${location}" == "dev" ]; then
		cd "/c/dev/"
	elif [ "${location}" == "iv" ]; then
		cd "/c/dev/iv/"
	elif [ "${location}" == "doc" ]; then
		cd "/c/dev/voortbrenging/"
	elif [ "${location}" == "dxp" ]; then
		cd "/c/dev/voortbrenging/iv-local-dev/"
	elif [ "${location}" == "62" ]; then
		cd "/c/dev/voortbrenging/iv-local-ee-dev/"
	fi
}

function docker-env {
    dockerEnv=$1
    if [ "${dockerEnv}" == "local" ]; then
        export DOCKER_TLS_VERIFY=
        export COMPOSE_TLS_VERSION=
        export DOCKER_CERT_PATH=
        export DOCKER_HOST=
    elif [ "${dockerEnv}" == "so" ]; then
        export DOCKER_TLS_VERIFY=1
        export COMPOSE_TLS_VERSION=TLSv1_2
        export DOCKER_CERT_PATH=C:\\dev\\certificates\\iv-online-manager-so
        export DOCKER_HOST=tcp://docker-manager.domain.com:8443
    fi

	echo "Current Docker Enviornment settings:";
	echo "";
	echo "DOCKER_TLS_VERIFY:   " $DOCKER_TLS_VERIFY;
	echo "COMPOSE_TLS_VERSION: " $COMPOSE_TLS_VERSION;
	echo "DOCKER_CERT_PATH:    " $DOCKER_CERT_PATH;
	echo "DOCKER_HOST:         " $DOCKER_HOST;
}

# Set up ssh-agent
SSH_ENV="$HOME/.ssh/environment"
function activate_agent {
    echo "Initializing new SSH agent..."
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
