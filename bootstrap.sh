#!/usr/bin/env bash

install_bash() {
    #if an old bashrc file exists make a backup of it
    if [[ -f ~/.bashrc ]]; then

        if [[ ! $(grep "#DOTFILES GENERATED" ~/.bashrc) ]]; then
            cat ~/.bashrc >> ~/bashrc_old
        fi

        rm -f ~/.bashrc
    fi

    #Move own bashrc to default location
    ln -s ./.bash_profile ~/.bash_profile
    ln -s ./.bashrc ~/.bashrc
}

install_gitconfig() {
    #install needed packages
    #isinstalled "npm" ||sudo yum install -y bind-utils
    #isinstalled "npm" || echo "WARNING: gitconfig needs npm installed."
    #hasnpmpackage "diff-so-fancy" || sudo npm --global install diff-so-fancy
    #hasnpmpackage "diff-so-fancy" || echo "WARNING: gitconfig needs the npm package diff-so-fancy."

    #if an old bashrc file exists make a backup of it
    if [[ -f ~/.gitconfig ]]; then

        if [[ ! $(grep ";DOTFILES GENERATED" ~/.gitconfig) ]]; then
            cat ~/.gitconfig >> ~/gitconfig_local
        fi

        rm -f ~/.gitconfig
    fi

    #Move own bashrc to default location
    ln -s ./.gitconfig ~/.gitconfig
}

install_minttyrc() {
    #if an old bashrc file exists make a backup of it
    if [[ -f ~/.minttyrc ]]; then

        if [[ ! $(grep "#DOTFILES GENERATED" ~/.minttyrc) ]]; then
            cat ~/.minttyrc > ~/minttyrc_old
        fi

        rm -f ~/.minttyrc
    fi

    #Move own bashrc to default location
    ln -s ./.minttyrc ~/.minttyrc
}

install_editorconfig() {
    if [[ -f ~/.editorconfig ]]; then

        if [[ ! $(grep "#DOTFILES GENERATED" ~/.editorconfig) ]]; then
            cat ~/.editorconfig > ~/editorconfig_old
        fi

        rm -f ~/.editorconfig
    fi

    #Make symlink of editorconfig to default location
    ln -s ./.editorconfig ~/.editorconfig
}

install_bash
install_gitconfig
install_minttyrc
install_editorconfig
