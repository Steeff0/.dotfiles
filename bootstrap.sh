#!/usr/bin/env bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Make symlink in the home folder to .dotfiles if not exists.
# This way scripts can keep referring to .dotfiles directory even if this is on another location.
if [ ! -d "${HOME}/.dotfiles" ]; then
    ln -s DOTFILES_DIR ${HOME}/.dotfiles
fi

source ${DOTFILES_DIR}/bash_functions.d/shell.sh

processFile() {
    if [ $# -lt 2 ]; then
        echo "Need at least a source file and a destination file"
        exit 1
    fi
    sourceFile=$1
    SymlinkFileLocation=$2
    backupDir="${HOME}/.dotfiles_old"

    if [ ! -f $sourceFile ]; then
        echo "File ${sourceFile} doesn't exists"
        exit 1
    fi

    createLocal=false
    if [ $# -gt 2 ] && [$3 = true]; then
        createLocal=true
    fi

    #if an old bashrc file exists make a backup of it
    if [[ -f ${SymlinkFileLocation} ]]; then
        fileToBackup="$SymlinkFileLocation"

        # If we want to create a local file and it already exists it needs a back-up
        # If it doesn't exists yet, nothing needs a back-up
        if [ ${createLocal} = true ]; then
            if [ -f "${SymlinkFileLocation}_local" ]; then
                fileToBackup="${SymlinkFileLocation}_local"
            else
                fileToBackup=""
            fi
        fi

        if [[ -f ${fileToBackup} ]] && [[ ! -L ${fileToBackup} ]]; then
            # To make sure the backup is unique (in case of doing this more often), add a short sha of the file
            shaChecksum=$(sha256sum ${fileToBackup})
            shaChecksum=${shaChecksum:0:10}

            # Make a folder as backup location for existing dotfiles.
            if [ ! -d "${backupDir}" ]; then
                mkdir ${backupDir}
            fi
            mv -f ${fileToBackup} "${backupDir}/$(basename $fileToBackup)_${shaChecksum}_old"
        fi

        # If we want to create a local file, then move the old file to file_local
        if [ ${createLocal} = true ]; then
            mv -f ${SymlinkFileLocation} "${SymlinkFileLocation}_local"
        fi

        # It is a symlink just remove it.
        if [ -L ${SymlinkFileLocation} ]; then
            rm -f ${SymlinkFileLocation}
        fi
    fi

    # Create symlink form source to destination
    link ${sourceFile} ${SymlinkFileLocation}
}

processFile ${DOTFILES_DIR}/.bash_profile ${HOME}/.bash_profile
processFile ${DOTFILES_DIR}/.bashrc ${HOME}/.bashrc true
processFile ${DOTFILES_DIR}/.gitconfig ${HOME}/.gitconfig true
processFile ${DOTFILES_DIR}/.minttyrc ${HOME}/.minttyrc
processFile ${DOTFILES_DIR}/.editorconfig ${HOME}/.editorconfig
