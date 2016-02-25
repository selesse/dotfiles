# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

# lets you use vi keybindings, use escape char and navigate, use v to
# have current line(s) open up in vim
set -o vi
# history file management
[ -f "$HOME/bin/merge_history.bash" ] && source "$HOME/bin/merge_history.bash" # source http://ptspts.blogspot.ca/2011/03/how-to-automatically-synchronize-shell.html
[ -f "$HOME/.git-completion.bash" ] && source $HOME/.git-completion.bash
export HISTCONTROL=erasedups
export HISTFILESIZE=10000
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "

color_off='\e[0m'
black='\e[0;30m'
red='\e[0;31m'
green='\e[0;32m'
yellow='\e[0;33m'
blue='\e[0;34m'
purple='\e[0;35m'
cyan='\e[0;36m'
white='\e[0;37m'

bblack='\e[1;30m'
bred='\e[1;31m'
bgreen='\e[1;32m'
byellow='\e[1;33m'
bblue='\e[1;34m'
bpurple='\e[1;35m'
bcyan='\e[1;36m'
bwhite='\e[1;37m'

# OS-specific aliases
case "`uname -s`" in
  "Darwin")
    alias ls="ls -G"
    alias l="ls -GF"

    PS1="[\[${bgreen}\]\w\[${color_off}\]] \$ "
    PROMPT_COMMAND='echo -ne "\033]0;${PWD}\007"'
    export JAVADIR=/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home
  ;;
  "FreeBSD")
    alias ls="ls -G"
    alias l="ls -GF"
    PS1="[\[${bgreen}\]\u\[${color_off}\]@\[${bred}\]\h\[{$color_off}\]][\[${bblue}\]\w\[${color_off}\]] \$ "
    if [ "${USER}" == "root" ] ; then
      PS1"[\[$byellow\]\u\[${color_off}\]@\[${bred}\]\h\[${color_off}\]][\[${bblue}\]\w\[${color_off}\]] \$ "
    fi
    PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME} - ${PWD}\007"'
  ;;
  *)
    alias ls="ls --color"
    alias l="ls --color -F"
    PS1="[\[${bgreen}\]\u\[${color_off}\]@\[${bred}\]\h\[${color_off}\]][\[${bblue}\]\w\[${color_off}\]] \$ "
    if [ "${USER}" == "root" ] ; then
      PS1="[\[${byellow}\]\u\[${color_off}\]@\[${bred}\]\h\[${color_off}\]][\[${bblue}\]\w\[${color_off}\]] \$ "
    fi
    PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME} - ${PWD}\007"'
    linuxlogo -u 2> /dev/null
  ;;
esac

################################################################################
# COMMON ALIASES
################################################################################
# aliases for ssh
if [ -f "$HOME/.local_aliases" ] ; then
  source "$HOME/.local_aliases"
fi

# dropbox aliases
alias config="cd ~/git/dotfiles"

alias diff="colordiff -u"
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
export GREP_OPTIONS="--color"

################################################################################
# PATH, ENVIRONMENT VARIABLES
################################################################################

HISTSIZE=50000
HISTFILESIZE=50000
SSH_ENV="$HOME/.ssh/environment"

function cd() {
  if [ -z "$@" ] ; then
    return
  fi
  builtin cd "$@" && ls
}

# function for extracting zip/tar files
function extract() {
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
    if [ $? -eq 2 ]; then
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

ls

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
