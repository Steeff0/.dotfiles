#!/bin/bash

function htpasswd() {
    npx htpasswd $@
}

function fix_blocked_ssh_by_proxy() {
    if [ -z "$1" ] && [ -z "$2" ]; then
        echo "The 'fix_blocked_ssh_by_proxy' function needs a host and port as parameters"
        exit 1
    fi
    if [ ! -f ~/.ssh/config ] || [[ ! $(grep "Host github.com" ~/.ssh/config) ]]; then
        cat << EOF >> ~/.ssh/config
Host github.com
    Hostname ssh.github.com
    ProxyCommand connect.exe -H [${1}:${2}] %h %p
    Port 443
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/id_rsa
    IdentitiesOnly yes
EOF
        echo "Added"
    else
        echo "Host github.com already defined in ~/.ssh/config"
    fi
}

function fix_ssh_to_443() {
    if [ ! -f ~/.ssh/config ] || [[ ! $(grep "Host github.com" ~/.ssh/config) ]]; then
        cat << EOF >> ~/.ssh/config
Host github.com
    Hostname ssh.github.com
    Port 443
    User git
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/id_rsa
    IdentitiesOnly yes
EOF
        echo "Added"
    else
        echo "Host github.com already defined in ~/.ssh/config"
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
