#!/bin/env bash

if [[ -f ~/.bashrc ]]; then
    mv ~/.bashrc ~/.bashrc.old
fi

if [[ -f ~/.gitconfig ]]; then
    mv ~/.gitconfig ~/.gitconfig.old
fi

if [[ -f ~/.vim ]]; then
    mv ~/.vim ~/.vim.old
fi

if [[ -f ~/.vimrc ]]; then
    mv ~/.vimrc ~/.vimrc.old
fi

ln -s ~/.dotfiles/.bashrc ~/.bashrc
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.vim ~/.vim
ln -s ~/.dotfiles/.vim/vimrc ~/.vimrc
