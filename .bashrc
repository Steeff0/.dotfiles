# Define own dirname
my_dir="$(dirname "$0")"

# Include old bash script if available but overwrite everything that was in there.
if [[ -f $my_dir/.bashrc.old ]]; then
  "$my_dir/.bashrc.old"
fi

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Set terminal title through xterm control sequence
echo -ne "\e]0;$(hostname)\a"

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Enable bash completion in interactive shells
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Source fzf.bash for fuzzy search
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Export localization variables
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Shell options
shopt -s globstar
shopt -s checkwinsize

# Various
alias ll='ls -alh --color=auto'
alias ls='ls --color=auto'
alias mkdir='mkdir -p'
alias cl='clear'
alias sshgo='eval $(ssh-agent) && ssh-add'
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias less='less -r'

# History
history -a
shopt -s histappend
export HISTFILESIZE=1000000
export HISTSIZE=100000
export HISTCONTROL=ignorespace
export HISTIGNORE='ls:history:ll'
export HISTTIMEFORMAT='%d-%m-%Y %T '

# Customize prompt PS1
my_prompt() {
  # get current branch in git repo
  function parse_git_branch() {
    BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    if [ ! "${BRANCH}" == "" ]
    then
      STAT=`parse_git_dirty`
      echo "[${BRANCH}${STAT}]"
    else
      echo ""
    fi
  }

  # get current status of git repo
  function parse_git_dirty {
    status=`git status 2>&1 | tee`
    dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
    untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
    ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
    newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
    renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
    deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
    bits=''
    if [ "${renamed}" == "0" ]; then
      bits=">${bits}"
    fi
    if [ "${ahead}" == "0" ]; then
      bits="*${bits}"
    fi
    if [ "${newfile}" == "0" ]; then
      bits="+${bits}"
    fi
    if [ "${untracked}" == "0" ]; then
      bits="?${bits}"
    fi
    if [ "${deleted}" == "0" ]; then
      bits="x${bits}"
    fi
    if [ "${dirty}" == "0" ]; then
      bits="!${bits}"
    fi
    if [ ! "${bits}" == "" ]; then
      echo " ${bits}"
    else
      echo ""
    fi
  }

  export PS1="[\[\e[32m\]\u\[\e[m\]\[\e[32m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\]:\w]\[\e[31m\]\`parse_git_branch\`\[\e[m\]\\$ "
}
PROMPT_COMMAND=my_prompt

# List bash aliases
la() {
    # Currently all my aliases are in .bashrc
    grep "^alias" ~/.bashrc  | cut -c 7- | sort
}

# Generate a random password
randpasswd() {
    tr -dc a-zA-Z0-9 < /dev/urandom | head -c${1:-32}; echo 1>&2;
}
