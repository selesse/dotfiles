ZSH=$HOME/.oh-my-zsh

ZSH_THEME="aseles"

# Red dots are displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

plugins=(ssh-agent tmux vundle)

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
  $HOME/bin
  $HOME/android-sdks/tools
  $HOME/android-sdks/platform-tools
  $HOME/.rvm/bin
  $HOME/git/gradle-1.8/bin
)

for dir in $PATHDIRS; do
  if [ -d "$dir" ]; then
    PATH+=$dir:
  fi
done

export VISUAL=vim
export EDITOR=vim

# use Vim key bindings
bindkey -v
bindkey jk vi-cmd-mode
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^[p' history-beginning-search-backward
bindkey '^[n' history-beginning-search-forward

case "`uname -s`" in
  "Darwin")
    alias ls="ls -G"
    alias l="ls -GF"

    # use jdk 7 by default:
    # http://stackoverflow.com/questions/12757558/installed-java-7-on-mac-os-x-but-terminal-is-still-using-version-6#comment21605776_12757565
    export JAVA_HOME=$(/usr/libexec/java_home -v 1.7)

    # homebrew
    PATH="/usr/local/bin:$PATH"

    # I don't care about my hostname when I'm on a physical device
    PROMPT_COMMAND='echo -ne "\033]0;${PWD}\007"'
  ;;
  "FreeBSD")
    alias ls="ls -G"
    alias l="ls -GF"
    PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME} - ${PWD}\007"'
  ;;
  *)
    # Don't be afraid of a little color in your life
    if [ ! -z "$COLORTERM" ] && [ "$TERM" == "xterm" ] ; then
      export TERM="xterm-256color"
    fi

    alias ls="ls --color"
    alias l="ls --color -F"
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'

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

alias config="cd ~/git/dotfiles"
alias public="cd ~/Dropbox/Public"

alias hisgrep="history | grep"
alias fname="find . -type f -name"
alias vi="vim"
alias duh="du -chs"
alias diff="colordiff -u"

[ -f "$HOME/.local_aliases" ] && source $HOME/.local_aliases
[ -f "$HOME/.mutt/gmail.muttrc" ] && alias email="mutt -F $HOME/.mutt/gmail.muttrc"

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

# Keep going up directories until you find "$file", or we reach root.
function find_parent_file {
  local file="$1"
  local directory="$PWD"
  local starting_directory="$directory"
  local target=""

  if [ -z "$file" ] ; then
    echo "Please specify a file to find"
  fi

  while [ -d "$directory" ] && [ "$directory" != "/" ]; do
    if [ `find "$directory" -maxdepth 1 -name "$file"` ] ; then
      target="$PWD"
      break
    else
      builtin cd .. && directory="$PWD"
    fi
  done

  builtin cd $starting_directory

  if [ -z "$target" ] ; then
    return 1
  fi

  echo $target
  return 0
}

function gw {
  # cd into the directory so you don't generate .gradle folders everywhere
  builtin cd `find_parent_file gradlew` && ./gradlew $*
  builtin cd -
}

function precmd() {
  local tab_label=${PWD/${HOME}/\~} # use 'relative' path
  echo -ne "\e]2;${tab_label}\a" # set window title to full string
}

################################################################################
# STARTUP COMMANDS
################################################################################

ls
