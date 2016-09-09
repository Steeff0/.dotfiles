# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# User specific aliases and functions
export PATH=$HOME/.config/composer/vendor/bin:$PATH
export GIT_SSL_NO_VERIFY=true

#shell options
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
alias gp='git push'
#alias diff='git difftool'
#alias merge='git mergetool'
alias gfs='git fetch -av && git status -v'

composer() { 
sudo mv /etc/php.d/xdebug.ini /etc/php.d/xdebug.ini-backup 
command composer $@
STATUS=$?
sudo mv /etc/php.d/xdebug.ini-backup /etc/php.d/xdebug.ini 
return $STATUS
}

alias composer=composer
