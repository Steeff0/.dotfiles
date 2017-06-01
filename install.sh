#!/bin/env bash

PARAMS=( "$@" )

if [[ $# -eq 0 ]]; then
  echo "Error: No parameter."
  echo "Pls add paramater what module to install."
  exit 1
fi

function isinstalled {
  if yum list installed "$@" >/dev/null 2>&1; then
    true
  else
    false
  fi
}

install_bash() {

  if ! isinstalled "bind-utils"; then
    sudo yum install -y bind-utils
  fi

  #if an old bashrc file exists make a backup of it
  if [[ -f ~/.bashrc ]]; then
      mv ~/.bashrc ~/.bashrc.local
  fi

  #Move own bashrc to default location
  ln -s ~/.dotfiles/.bashrc ~/.bashrc
}

install_gitconfig() {
  #if an old bashrc file exists make a backup of it
  if [[ -f ~/.gitconfig ]]; then
    mv ~/.gitconfig ~/.gitconfig.old
  fi

  #Move own bashrc to default location
  ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
}

install_vim() {
  #if an old bashrc file exists make a backup of it
  if [[ -f ~/.vim ]]; then
    mv ~/.vim ~/.vim.old
  fi

  #Move own bashrc to default location
  ln -s ~/.dotfiles/.vim ~/.vim
}

install_vimrc() {
  #if an old bashrc file exists make a backup of it
  if [[ -f ~/.vimrc ]]; then
    mv ~/.vimrc ~/.vimrc.old
  fi

  #Move own bashrc to default location
  ln -s ~/.dotfiles/.vim/vimrc ~/.vimrc
}

install_minttyrc() {
  #if an old bashrc file exists make a backup of it
  if [[ -f ~/.minttyrc ]]; then
    mv ~/.minttyrc ~/.minttyrc.old
  fi

  #Move own bashrc to default location
  ln -s ~/.dotfiles/.minttyrc ~/.minttyrc
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
    *)
      echo "Error: Unknown module."
      echo "Available: bash gitconfig vim vimrc minttyrc."
      ;;
  esac

done
