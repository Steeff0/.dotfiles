# shell options
shopt -s autocd

# general
alias cd..='cd ..'
alias ..='cd ..'
alias .2='cd ../..'
alias .3='cd ../../../'
alias .4='cd ../../../..'
alias h='history'
alias j='jobs -l'
alias ll='ls -alh'
alias mkdir='mkdir -p'
alias cl='clear'
alias sushigo='eval $(ssh-agent) && ssh-add'
alias v='vim'
alias ls='ls -la --color=auto'
export HISTTIMEFORMAT="%d-%m-%y %T "

# git
alias ga='git add'
alias gs='git status'
alias gc='git commit'
alias gl='git l'
alias gf='git fetch --all'
#alias diff='git difftool'
#alias merge='git mergetool'
alias gfs='git fetch -av && git status -v'

