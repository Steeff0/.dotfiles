#!/bin/bash

# Replacement of the windows nvm use function that doesn't touch your env vars
function nvm_use() {
    if [ $# -ge 1 ]; then
        version="$(echo $1 | sed "s/^v//")"
        if [ -d "${NVM_HOME}/v${version}" ]; then

            if [ -d "${NVM_SYMLINK}" ]; then
                rm -rf "${NVM_SYMLINK}"
            fi

            link "${NVM_HOME}/v${version}" "${NVM_SYMLINK}"

            # Make sure the node executable has the correct name
            if [ -f "${NVM_HOME}/v${version}/node.exe" ]; then
                if [ -f "${NVM_HOME}/v${version}/node64.exe" ]; then
                    mv "${NVM_HOME}/v${version}/node.exe" "${NVM_HOME}/v${version}/node32.exe"
                    mv "${NVM_HOME}/v${version}/node64.exe" "${NVM_HOME}/v${version}/node.exe"
                fi

            else
                if [ -f "${NVM_HOME}/v${version}/node64.exe" ]; then
                    mv "${NVM_HOME}/v${version}/node64.exe" "${NVM_HOME}/v${version}/node.exe"
                elif [ -f "${NVM_HOME}/v${version}/node32.exe" ]; then
                    mv "${NVM_HOME}/v${version}/node32.exe" "${NVM_HOME}/v${version}/node.exe"
                fi
            fi
        else
            echo "Node version is not installed. Please first run 'nvm install Node ${version}' then try nvm use again"
            exit 1
        fi
    else
        nvm $@
    fi
}

# Replacement of the windows nvm executable that doesn't touch your env vars when you use use, and can handle .nvmrc files
function nvmi() {
    if [ $# -ge 1 ] && [ "${1}" == "use" ] && [ -f .nvmrc ]; then
        version="$(cat .nvmrc)"
        nvm_use $version
    elif [ "${1}" == "use" ]; then
        shift
        nvm_use $@
    else
        nvm $@
    fi
}
