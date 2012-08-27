# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash and not root (root calls ~/.bashrc - recursion problem)
if [ "${USER}" != "root" ]; then
  if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
      . "$HOME/.bashrc"
    fi
  fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

if [ `uname -s` == "Darwin" ] ; then
  # mac specific things
  PATH=$PATH:$HOME/chromium/depot_tools/:/opt/local/bin/

  alias ls="ls -G"
  alias l="ls -GF"
  PS1="[\[\e[1;32m\]\w\[\e[m\]] > "
  PROMPT_COMMAND='echo -ne "\033]0;${PWD}\007"'
else
  # linux specific things
  alias ls="ls --color"
  alias l="ls --color -F"
  alias hb="HandBrakeCLI"
  alias www="cd ~/www/"
  alias atop="sudo atop -m"
  PS1='[\[\e[1;32m\]\u\[\e[m\]@\[\e[1;31m\]\h\[\e[m\]][\[\e[1;34m\]\w\[\e[m\]] > '
  # change the color of root
  if [ "${USER}" == "root" ] ; then
    PS1='[\[\e[1;33m\]\u\[\e[m\]@\[\e[1;31m\]\h\[\e[m\]][\[\e[1;34m\]\w\[\e[m\]] > '
  fi
  PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME} - ${PWD}\007"'
fi


PATH=$PATH":./"
export EDITOR=vim
export VISUAL=vim

alias config="cd ~/git/config"

# aliases for ssh
alias ubuntu="ssh aseles1@ubuntu.cs.mcgill.ca"
alias mimi="ssh aseles1@mimi.cs.mcgill.ca"
alias selerver="ssh alex@selesse.com"
alias swmud="rlwrap telnet swmud.org 6666"
alias mq="ssh merqumab@sunnysuba.com -p 2222"

# dropbox aliases
alias public="cd ~/Dropbox/Public"
alias school="cd ~/Dropbox/McGill"
alias os="cd ~/Dropbox/McGill/OS"
alias ai="cd ~/Dropbox/McGill/AI"
alias 360="cd ~/Dropbox/McGill/COMP360"
alias db="cd ~/Dropbox/McGill/Database"
alias dp="cd ~/Dropbox/McGill/DP"

# function for cd + ls combo
function cd () {
  if [ -z "$1" ] ; then
    return
  fi
  builtin cd "$@" && ls
}

# function for extracting zip/tar files
extract () {
  if [ -f $1 ] ; then
    case $1 in
    *.tar.bz2)  tar xjf $1      ;;
    *.tar.gz)   tar xzf $1      ;;
    *.bz2)      bunzip2 $1      ;;
    *.rar)      rar x $1        ;;
    *.gz)       gunzip $1       ;;
    *.tar)      tar xf $1       ;;
    *.tbz2)     tar xjf $1      ;;
    *.tgz)      tar xzf $1      ;;
    *.zip)      unzip $1        ;;
    *.Z)        uncompress $1   ;;
    *)          echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file - go home"
  fi
}

SSH_ENV="$HOME/.ssh/environment"

# start the ssh-agent
function start_agent {
  echo "Initializing new SSH agent..."
  # spawn ssh-agent
  ssh-agent | sed 's/^echo/#echo/' > "$SSH_ENV"
  echo succeeded
  chmod 600 "$SSH_ENV"
  . "$SSH_ENV" > /dev/null
  ssh-add
}

# test for identities
function test_identities {
  # test whether standard identities have been added to the agent already
  ssh-add -l | grep "The agent has no identities" > /dev/null
  if [ $? -eq 0 ]; then
    ssh-add
    # $SSH_AUTH_SOCK broken so we start a new proper agent
    if [ $? -eq 2 ];then
      start_agent
    fi
  fi
}

if [ "${USER}" != "root" ] ; then
  # check for running ssh-agent with proper $SSH_AGENT_PID
  if [ -n "$SSH_AGENT_PID" ]; then
    ps -ef | grep "$SSH_AGENT_PID" | grep ssh-agent > /dev/null
    if [ $? -eq 0 ]; then
      test_identities
    fi
    # if $SSH_AGENT_PID is not properly set, we might be able to load one from
    # $SSH_ENV
  else
    if [ -f "$SSH_ENV" ]; then
      . "$SSH_ENV" > /dev/null
    fi
    ps -ef | grep "$SSH_AGENT_PID" | grep -v grep | grep ssh-agent > /dev/null
    if [ $? -eq 0 ]; then
      test_identities
    else
      start_agent
    fi
  fi
fi

# git diff --diff-filter=D --name-only -z | xargs -0 git rm

HISTFILESIZE=50000

ls
