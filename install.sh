#!/bin/env bash

PARAMS=( "$@" )

if [[ $# -eq 0 ]]; then
    echo "Error: No parameter."
    echo "Pls add paramater what module to install."
    exit 1
fi

function isinstalled {
    yum list installed "$@" >/dev/null 2>&1 && return 0 || return 1
}

function hasnpmpackage {
    npm --global ls | grep "$@" >/dev/null 2>&1 && return 0 || return 1
}

install_bash() {
    #install needed packages
    #isinstalled "bind-utils" || sudo yum install -y bind-utils
    isinstalled "bind-utils" || echo 'WARNING: bashrc needs bind-utils programs like "dig" and "host".'

    #if an old bashrc file exists make a backup of it
    if [[ -f ~/.bashrc ]] && [[ ! -f ~/.bashrc.local ]]; then
        mv ~/.bashrc ~/.bashrc.local
    elif [[ -f ~/.bashrc ]]; then
      rm -f ~/.bashrc
    fi

    #Move own bashrc to default location
    ln -s ~/.dotfiles/.bashrc ~/.bashrc
}

install_gitconfig() {
    #install needed packages
    #isinstalled "npm" ||sudo yum install -y bind-utils
    isinstalled "npm" || echo "WARNING: gitconfig needs npm installed."
    #hasnpmpackage "diff-so-fancy" || sudo npm --global install diff-so-fancy
    hasnpmpackage "diff-so-fancy" || echo "WARNING: gitconfig needs the npm package diff-so-fancy."

    #if an old gitconfig file exists make a backup of it
    if [[ -f ~/.gitconfig ]] && [[ ! -f ~/.gitconfig.old ]]; then
        mv ~/.gitconfig ~/.gitconfig.old
    elif [[ -f ~/.gitconfig ]]; then
      rm -f ~/.gitconfig
    fi

    #Move own bashrc to default location
    ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
}

install_vim() {
    #if an old vim file exists make a backup of it
    if [[ -f ~/.vim ]] && [[ ! -f ~/.vim.old ]]; then
        mv ~/.vim ~/.vim.old
    elif [[ -f ~/.vim ]]; then
      rm -f ~/.vim
    fi

    #Move own bashrc to default location
    ln -s ~/.dotfiles/.vim ~/.vim
}

install_vimrc() {
    #if an old vimrc file exists make a backup of it
    if [[ -f ~/.vimrc ]] && [[ ! -f ~/.vimrc.old ]]; then
        mv ~/.vimrc ~/.vimrc.old
    elif [[ -f ~/.vimrc ]]; then
      rm -f ~/.vimrc
    fi

    #Move own bashrc to default location
    ln -s ~/.dotfiles/.vim/vimrc ~/.vimrc
}

install_minttyrc() {
    #if an old bashrc file exists make a backup of it
    if [[ -f ~/.minttyrc ]] && [[ ! -f ~/.minttyrc.old ]]; then
        mv ~/.minttyrc ~/.minttyrc.old
    elif [[ -f ~/.minttyrc ]]; then
      rm -f ~/.minttyrc
    fi

    #Move own bashrc to default location
    ln -s ~/.dotfiles/.minttyrc ~/.minttyrc
}

fix_ssh_to_443() {
    if [ ! -f ~/.ssh/config ] || grep "Host github.com" ~/.ssh/config; then
        sudo tee -a ~/.ssh/config <<EOF
Host github.com
    Hostname ssh.github.com
    Port 443
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/id_rsa

EOF
    fi
}

# Switch over input parameters and determine logic to execute
for PARAM in $PARAMS
do

    case $PARAM in
        "bash")
            install_bash
        ;;
        "gitconfig")
            install_gitconfig
        ;;
        "vim")
            install_vim
        ;;
        "vimrc")
            install_vimrc
        ;;
        "minttyrc")
            install_minttyrc
        ;;
        "sshfix")
            fix_ssh_to_443
        ;;
        *)
            echo "Error: Unknown module."
            echo "Available: bash gitconfig vim vimrc minttyrc sshfix."
        ;;
    esac

done
