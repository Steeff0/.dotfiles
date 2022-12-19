#!/bin/bash

alias ll='ls -alh --color=auto'
alias ls='ls --color=auto'
alias mkdir='mkdir -p'
alias cl='clear'
alias npm-no-cache-install='echo "LEEROY JENKINS ! ! !" && rm -rf node_modules && rm -rf package-lock.json && npm cache clean -f && npm install --cache ./tmp && rm -rf tmp'
alias k='kubectrl'

function htpasswd() {
    npx htpasswd $@
}

# List bash aliases
function la() {
    # Currently all my aliases are in .bashrc
    grep "^alias" ~/.bashrc  | cut -c 7- | sort
}


function docker-exec {
    if [ ! $# -ge 2 ]; then
        echo "The 'docker-exec' command needs a container hash (param 1) and command as parameter(s)"
    else
        docker exec -it $@
    fi
}

function docker-bash {
    if [ -z "$1" ]; then
        echo "The 'docker-bash' command needs a container name as parameter"
    else
        docker-exec $1 bash
    fi
}
