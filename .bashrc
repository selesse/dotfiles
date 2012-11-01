# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

# lets you use vi keybindings, use escape char and navigate, use v to
# have current line(s) open up in vim
set -o vi
# history file management
source "$HOME/bin/merge_history.bash" # source http://ptspts.blogspot.ca/2011/03/how-to-automatically-synchronize-shell.html
source ~/.git-completion.bash

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


# OS-specific aliases
case "`uname -s`" in
  "Darwin")
    alias ls="ls -G"
    alias l="ls -GF"
    alias mvim="$HOME/Downloads/MacVim-snapshot-65/mvim -v"
    alias vim="mvim"
    # I don't care about my hostname when I'm on my local mac
    PS1="[\[\e[1;32m\]\w\[\e[m\]] > "
    PROMPT_COMMAND='echo -ne "\033]0;${PWD}\007"'
  ;;
  "FreeBSD")
    alias ls="ls -G"
    alias l="ls -GF"
  ;;
  *)
    alias ls="ls --color"
    alias l="ls --color -F"
    alias hb="HandBrakeCLI"
    PS1='[\[\e[1;32m\]\u\[\e[m\]@\[\e[1;31m\]\h\[\e[m\]][\[\e[1;34m\]\w\[\e[m\]] > '
    # change the color of root
    if [ "${USER}" == "root" ] ; then
      PS1='[\[\e[1;33m\]\u\[\e[m\]@\[\e[1;31m\]\h\[\e[m\]][\[\e[1;34m\]\w\[\e[m\]] > '
    fi
    PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME} - ${PWD}\007"'
    linuxlogo -u
  ;;
esac

################################################################################
# COMMON ALIASES
################################################################################
# aliases for ssh
alias ubuntu="ssh aseles1@ubuntu.cs.mcgill.ca"
alias mimi="ssh aseles1@mimi.cs.mcgill.ca"
alias selerver="ssh alex@selesse.com"
alias swmud="rlwrap telnet swmud.org 6666"
alias mq="ssh merqumab@sunnysuba.com -p 2222"

# dropbox aliases
alias config="cd ~/git/config"
alias public="cd ~/Dropbox/Public"
alias school="cd ~/Dropbox/McGill"
alias os="cd ~/Dropbox/McGill/OS"
alias ai="cd ~/Dropbox/McGill/AI"
alias 360="cd ~/Dropbox/McGill/COMP360"
alias db="cd ~/Dropbox/McGill/Database"
alias dp="cd ~/Dropbox/McGill/DP"
alias tiny='cd ~/git/cs520/git/group-d/tiny/sablecc-3'

alias vi="vim"
alias wig="cd $HOME/git/cs520/git/group-d/wig/src"

################################################################################
# PATH, ENVIRONMENT VARIABLES
################################################################################
export ANDROID_HOME="$HOME/android-sdk"
PATH="$PATH:$ANDROID_HOME:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"
PATH="$PATH:$HOME/Dropbox/sablecc-3.6/bin:$HOME/Dropbox/McGill/ECSE429 - Software Validation/Spin/Src6.2.2"
export JAVADIR=/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home
export JOOSDIR=$HOME/git/cs520/public_html/joos
export CLASSPATH=$JOOSDIR/jooslib.jar:$CLASSPATH
export PATH=$JAVADIR/bin:$HOME/git/cs520/git/group-d/joos/scanparse:$JOOSDIR/bin:$PATH:$HOME/git/cs520/git/group-d/wig/src
export WIGGLEDIR=$HOME/git/cs520/git/group-d/wig/src
export EDITOR=vim
export VISUAL=vim
HISTSIZE=50000
HISTFILESIZE=50000
SSH_ENV="$HOME/.ssh/environment"

# function for cd + ls combo, needs to come after ls alias
function cd () {
  if [ -z "$1" ] ; then
    return
  fi
  builtin cd "$@" && ls
}

ls
