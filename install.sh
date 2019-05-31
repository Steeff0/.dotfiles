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

        if [[ ! -f ~/bashrc.local ]] && [[ ! $(grep "#DOTFILES GENERATED" ~/.bashrc) ]]; then
            cat ~/.bashrc >> ~/bashrc.local
        elif [[ ! $(grep "#DOTFILES GENERATED" ~/.bashrc) ]]; then
            cat ~/.bashrc >> ~/bashrc.bac
        fi

        rm -f ~/.bashrc
    fi

    #Move own bashrc to default location
    cp -uf $(PWD)/promptCommand.sh ~/promptCommand.sh
    cp -uf $(PWD)/.bashrc ~/.bashrc
}

install_gitconfig() {
    #install needed packages
    #isinstalled "npm" ||sudo yum install -y bind-utils
    #isinstalled "npm" || echo "WARNING: gitconfig needs npm installed."
    #hasnpmpackage "diff-so-fancy" || sudo npm --global install diff-so-fancy
    #hasnpmpackage "diff-so-fancy" || echo "WARNING: gitconfig needs the npm package diff-so-fancy."

    #if an old bashrc file exists make a backup of it
    if [[ -f ~/.gitconfig ]]; then

        if [[ ! -f ~/gitconfig.local ]] && [[ ! $(grep ";DOTFILES GENERATED" ~/.gitconfig) ]]; then
            cat ~/.gitconfig >> ~/gitconfig.local
        elif [[ ! $(grep ";DOTFILES GENERATED" ~/.bashrc) ]]; then
            cat ~/.gitconfig >> ~/gitconfig.bac
        fi

        rm -f ~/.gitconfig
    fi

    #Move own bashrc to default location
    cp -uf $(PWD)/.gitconfig ~/.gitconfig
}

install_minttyrc() {
    #if an old bashrc file exists make a backup of it
    if [[ -f ~/.minttyrc ]]; then

        if [[ ! $(grep "#DOTFILES GENERATED" ~/.minttyrc) ]]; then
            cat ~/.minttyrc > ~/minttyrc.old
        fi

        rm -f ~/.minttyrc
    fi

    #Move own bashrc to default location
    cp -uf $(PWD)/.minttyrc ~/.minttyrc
}

fix_ssh_to_443() {
    if [ ! -f ~/.ssh/config ] || [[ ! $(grep "Host github.com" ~/.ssh/config) ]]; then
        cat << EOF >> ~/.ssh/config
Host github.com
    Hostname ssh.github.com
    Port 443
	User git
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/id_rsa
EOF
        echo "Added"
    else
        echo "Host github.com already defined in ~/.ssh/config"
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
