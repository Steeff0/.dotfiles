alias d='winpty docker'
alias dc='docker-compose'
alias k='kubectrl'

# Userful functions
function docker-bash {
    if [ -z "$1" ]; then
        echo "The 'docker-bash' command needs a container name as parameter"
    else
        winpty docker exec -it "$1" bash
    fi
}
