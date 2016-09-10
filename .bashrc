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
alias ll='ls -alh --color=auto'
alias ls='ls --color=auto'
alias mkdir='mkdir -p'
alias cl='clear'
alias sshgo='eval $(ssh-agent) && ssh-add'
alias v='vim'
alias ls='ls -la --color=auto'
alias clipkey='cat ~/.ssh/id_rsa.pub > /dev/clipboard'
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

# Replacement for composer without xdebug enabled
composer() { 
	sudo mv /etc/php.d/xdebug.ini /etc/php.d/xdebug.ini-backup 
	command composer $@
	STATUS=$?
	sudo mv /etc/php.d/xdebug.ini-backup /etc/php.d/xdebug.ini 
	return $STATUS
}

alias composer=composer

# Shorcut function for git add, git commit, git push
gacp() {
	git add . && git commit -m "$1" && git push
}

