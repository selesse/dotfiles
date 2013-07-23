# Path to oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

ZSH_THEME="aseles"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

plugins=(git ssh-agent tmux vundle)

setopt extendedglob
unsetopt nomatch

source $ZSH/oh-my-zsh.sh

PATHDIRS=(
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  /usr/local/bin
  /usr/local/sbin
  /usr/X11/bin
  /usr/lib/jvm/java-1.7.0-openjdk-i386/jre/bin
  $HOME/android-sdks/tools
  $HOME/android-sdks/platform-tools
  $HOME/.rvm/bin
  $HOME/git/gradle-1.6/bin
)

for dir in $PATHDIRS; do
  if [ -d "$dir" ]; then
    PATH+=$dir
  fi
done

PATH=$HOME/bin:$PATH

export VISUAL=vim
export EDITOR=vim

case "`uname -s`" in
  "Darwin")
    alias ls="ls -G"
    alias l="ls -GF"

    export JAVADIR=/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home

    # I don't care about my hostname when I'm on my mac
    PROMPT_COMMAND='echo -ne "\033]0;${PWD}\007"'
  ;;
  "FreeBSD")
    alias ls="ls -G"
    alias l="ls -GF"
    PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME} - ${PWD}\007"'
  ;;
  *)
    alias ls="ls --color"
    alias l="ls --color -F"

    function say() {
      espeak -s 120 "$@" > /dev/null 2>&1
    }

    # change the color of root
    PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME} - ${PWD}\007"'
    linuxlogo -u 2> /dev/null
  ;;
esac

################################################################################
# COMMON ALIASES
################################################################################
alias swmud="rlwrap telnet swmud.org 6666"

alias config="cd ~/git/config"
alias public="cd ~/Dropbox/Public"

alias hisgrep="history | grep"
alias fname="find . -name"
alias vi="vim"
alias duh="du -chs"
alias diff="colordiff -u"

if [ -f "$HOME/.local_aliases" ] ; then
  source $HOME/.local_aliases
fi

################################################################################
# COMMON EXPORTS
################################################################################

export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
export GREP_OPTIONS="--color"

################################################################################
# COMMON FUNCTIONS
################################################################################

function cd() {
  if [ -z "$@" ] ; then
    return
  fi
  builtin cd "$@" && ls
}

function extract () {
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

function psgrep() {
  ps aux |
  grep -v grep | #exclude this grep from the results
  grep "$@" -i --color=auto;
}

################################################################################
# STARTUP COMMANDS
################################################################################

ls
