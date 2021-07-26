#!/bin/bash

# Userful functions
function docker-exec {
    if [ ! $# -ge 2 ]; then
        echo "The 'docker-exec' command needs a container hash (param 1) and command as parameter(s)"
    else
        container="$1"
        shift
        winpty docker exec -it "${container}" $@
    fi
}

function docker-bash {
    if [ -z "$1" ]; then
        echo "The 'docker-bash' command needs a container name as parameter"
    else
        docker-exec $1 bash
    fi
}

alias d='winpty docker'
alias de='docker-exec'
alias dc='docker-compose'
alias k='kubectrl'
