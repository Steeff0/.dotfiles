#!/usr/bin/env bash
#not supposed to run
exit 1

# Navigation not interested right now
shopt -s autocd
alias cd..='cd ..'
alias ..='cd ..'
alias .2='cd ../..'
alias .3='cd ../../../'
alias .4='cd ../../../..'
alias -- -="cd -"

# Various
alias h='history'
alias j='jobs -l'
alias v='vim'
alias clipkey='cat ~/.ssh/id_rsa.pub > /dev/clipboard'

# Git
# Create g<alias> shortcuts for all git aliases and enable git autocompletion
function_exists() {
    declare -f -F $1 > /dev/null
    return $?
}

for al in `__git_aliases`; do
    alias g$al="git $al"

    complete_func=_git_$(__git_aliased_command $al)
    function_exists $complete_func && __git_complete g$al $complete_func
done

# Create a new directory and enter it
mkd() {
    mkdir -p "$@" && cd "$_";
}
