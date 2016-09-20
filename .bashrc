# Shell options
shopt -s autocd

# General
alias cd..='cd ..'
alias ..='cd ..'
alias .2='cd ../..'
alias .3='cd ../../../'
alias .4='cd ../../../..'
alias h='history'
alias j='jobs -l'
alias ll='ls -alh --color=auto'
alias ls='ls --color=auto'
alias mkdir='mkdir -p'
alias cl='clear'
alias sshgo='eval $(ssh-agent) && ssh-add'
alias v='vim'
alias ls='ls -la --color=auto'
alias clipkey='cat ~/.ssh/id_rsa.pub > /dev/clipboard'
export HISTTIMEFORMAT="%d-%m-%y %T "

# Create g<alias> shortcuts for all git aliases and enable git autocompletion
function_exists() {
    declare -f -F $1 > /dev/null
    return $?
}

for al in `__git_aliases`; do
    alias g$al="git $al"

    complete_func=_git_$(__git_aliased_command $al)
    function_exists $complete_fnc && __git_complete g$al $complete_func
done

my_prompt() {
    local branch=$(git branch 2>/dev/null | grep '^*' | sed s/..//)
    local branch_addition=""

    if [ -n "$branch" ]
    then
      branch_addition="@\[\033[38;5;202m\]${branch}\[\033[0m\]"
    fi

    export PS1="\u:\w${branch_addition}\\$ "
}

PROMPT_COMMAND=my_prompt
