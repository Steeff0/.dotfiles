#!/usr/bin/env bash

PARAMS=( "$@" )

if [[ $# -eq 0 ]]; then
    echo "Error: No parameter."
    echo "Pls add paramater what module to install."
    exit 1
fi

install_bash() {
    #if an old bashrc file exists make a backup of it
    if [[ -f ~/.bashrc ]]; then
        local generated=~/.bashrc | grep "#DOTFILES GENERATED"

        if [[ ! -f ~/.bashrc.local ]] && [[ ! generated ]]; then
            mv ~/.bashrc ~/.bashrc.local
        fi

        rm -f ~/.bashrc
    fi

    #Move own bashrc to default location
    cp -uf $(PWD)/.bashrc ~/.bashrc
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
        "minttyrc")
            install_minttyrc
        ;;
        "sshfix")
            fix_ssh_to_443
        ;;
        *)
            echo "Error: Unknown module."
            echo "Available: bash gitconfig minttyrc sshfix."
        ;;
    esac
done
