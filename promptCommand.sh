#!/usr/bin/env bash
promptCommand() {
    #COLOR CODES
    local GREEN="\[\033[0;32m\]"
    local CYAN="\[\033[0;36m\]"
    local BCYAN="\[\033[1;36m\]"
    local BLUE="\[\033[0;34m\]"
    local GRAY="\[\033[0;37m\]"
    local DKGRAY="\[\033[1;30m\]"
    local WHITE="\[\033[1;37m\]"
    local RED="\[\033[0;31m\]"
    # return color to Terminal setting for text color
    local DEFAULT="\[\033[0;39m\]"

    # SET BRANCH
    local BRANCH=""
    # if we're in a Git repo, show current branch
    local GIT_BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    if [ ! -z ${GIT_BRANCH} ]; then
        BRANCH=${GIT_BRANCH}
    elif [ -d ".svn" ]; then
        BRANCH="[ "`svn info | awk '/Last\ Changed\ Rev/ {print $4}'`" ]"
    fi
    #Show feature and other specific branches in green. Main branches in red.
    if [[ ! -z ${BRANCH} ]] && [[ "${BRANCH}" == *"/"* ]]; then
        BRANCH="${GREEN}[${BRANCH}]${WHITE} || "
    elif [[ ! -z ${BRANCH} ]]; then
        BRANCH="${RED}[${BRANCH}]${WHITE} || "
    fi

    # SET TIME
    local TIME=`date +"%H:%M:%S"`

    # SET CURRENT PATH
    local CURRENT_PATH=`echo ${PWD/#$HOME/\~}`
    # trim long path
    if [ ${#CURRENT_PATH} -gt "35" ]; then
        CURRENT_PATH=".../${PWD#${PWD%/*/*/*}/}/"
    fi

    # different prompt and color for root
    local PR_COLORED="${GREEN}$"
    local USERNAME_COLORED="${GREEN}${USER}"
    if [ "$UID" = "0" ]; then
        PR_COLORED="${RED}#"
        USERNAME_COLORED="${RED}${USER}$"
    fi

    local TOP_LINE="${CYAN}[ ${GRAY}${TIME} ${WHITE}|| ${BRANCH}${GRAY}${CURRENT_PATH}${CYAN}]"
    local BOTTOM_LINE="${CYAN}[${USERNAME_COLORED}${WHITE}@${GRAY}${HOSTNAME}${CYAN}]${PR_COLORED}${DEFAULT} "
    export PS1="\n${TOP_LINE}\n${BOTTOM_LINE}"
}
PROMPT_COMMAND=promptCommand