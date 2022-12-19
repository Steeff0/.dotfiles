#!/usr/bin/env bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source ${DOTFILES_DIR}/bash_functions.d/shell.sh

# Make symlink in the home folder to .dotfiles if not exists.
# This way scripts can keep referring to .dotfiles directory even if this is on another location.
if [ ! -d "${HOME}/.dotfiles" ]; then
    link ${DOTFILES_DIR} ${HOME}/.dotfiles
fi

function backupFile(){
    backupDir="${HOME}/.dotfiles_old"
    fileToBackup=$1

    # To make sure the backup is unique (in case of doing this more often), add a short sha of the file
    shaChecksum=$(sha256sum ${fileToBackup})
    shaChecksum=${shaChecksum:0:10}

    # Make a folder as backup location for existing dotfiles.
    if [ ! -d "${backupDir}" ]; then
        mkdir ${backupDir}
    fi
    cp -f ${fileToBackup} "${backupDir}/$(basename $fileToBackup)_${shaChecksum}_old"
}

processFile() {
    if [ $# -lt 2 ]; then
        echo "Need at least a source file and a destination file"
        exit 1
    fi
    sourceFile=$1
    symlinkFile=$2

    if [ ! -f $sourceFile ]; then
        echo "File ${sourceFile} doesn't exists"
        exit 1
    fi

    if [ $# -ge 3 ] && [ $3 = true ]; then
        createLocal=true
    fi

    #if an old bashrc file exists make a backup of it
    if [ -f ${symlinkFile} ]; then
        if [ ! -L ${symlinkFile} ]; then
            # It is not a symlink so sets backup the file before we continue
            if [ "${createLocal}" = true ] && [ -f "${symlinkFile}_local" ]; then
                # If we have to create a local and it already exists, backup the old local
                # Then move the symlink file to file_local
                backupFile "${symlinkFile}_local"
                rm "${symlinkFile}_local"
                cp -f ${symlinkFile} "${symlinkFile}_local"

            elif [ "${createLocal}" = true ]; then
                # There  is no file_local so just move the file
                cp -f ${symlinkFile} "${symlinkFile}_local"

            else
                # Just backup the file
                backupFile "$symlinkFile"

            fi
        fi
        rm -f "$symlinkFile"
    fi

    # Create symlink form source to destination
    link ${sourceFile} ${symlinkFile}
}

processFile ${DOTFILES_DIR}/ubuntu/.bash_aliases ${HOME}/.bash_aliases true
processFile ${DOTFILES_DIR}/.gitconfig ${HOME}/.gitconfig true
processFile ${DOTFILES_DIR}/.gitignore ${HOME}/.gitignore
processFile ${DOTFILES_DIR}/.editorconfig ${HOME}/.editorconfig
