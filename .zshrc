# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="aseles"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git ssh-agent)

setopt extendedglob

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
PATHDIRS=(
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  /usr/local/bin
  /usr/X11/bin
  /usr/lib/jvm/java-1.7.0-openjdk-i386/jre/bin
  $HOME/git/cs520/public_html/joos/bin
  /opt/local/bin
  $HOME/android-sdk
  $HOME/android-sdk/tools
  $HOME/android-sdk/platform-tools
  $HOME/Dropbox/sablecc-3.6/bin
  $HOME/git/cs520/git/group-d/wig/src
)

for dir in $PATHDIRS; do
  if [ -d $dir ]; then
    path+=$dir
  fi
done

PATH=$HOME/bin:$PATH

case "`uname -s`" in
  "Darwin")
    alias ls="ls -G"
    alias l="ls -GF"
    alias mvim="$HOME/Downloads/MacVim-snapshot-65/mvim -v"
    alias vim="mvim"

    PATH=$PATH:/opt/local/bin/
    PATH="$HOME/Library/Haskell/bin:$PATH"
    PATH=$PATH:/usr/local/texlive/2012/bin/x86_64-darwin

    # I don't care about my hostname when I'm on my local mac
    PROMPT_COMMAND='echo -ne "\033]0;${PWD}\007"'
    export JAVADIR=/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home
    export LEJOS_NXT_JAVA_HOME="$JAVADIR"
    export NXJ_HOME="$HOME/Downloads/lejos_nxj"
    export PATH="$PATH:$NXJ_HOME/bin"
  ;;
  "FreeBSD")
    alias ls="ls -G"
    alias l="ls -GF"
    PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME} - ${PWD}\007"'
  ;;
  *)
    alias ls="ls --color"
    alias l="ls --color -F"
    alias hb="HandBrakeCLI"
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
alias school="cd ~/Dropbox/McGill"

alias hisgrep="history | grep"
alias vi="vim"
alias duh="du -chs"
alias diff="colordiff -u"
alias fpg="find_parent_git"

if [ -f "$HOME/.local_aliases" ] ; then
  source $HOME/.local_aliases
fi

export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
export GREP_OPTIONS="--color"

function cd() {
  if [ -z "$@" ] ; then
    return
  fi
  builtin cd "$@" && ls
}

# function for extracting zip/tar files
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

ls

echo "selesse.com : Add clickable links for cheat sheets so you can see all commands"

export WIGDIR=$HOME/git/cs520/public_html/wig
export JOOSDIR=$HOME/git/cs520/public_html/joos
export CLASSPATH=$JOOSDIR/jooslib.jar:$CLASSPATH
export PATH=$PATH:$HOME/git/cs520/git/group-d/joos/peephole
export WIGGLEDIR=$HOME/git/cs520/git/group-d/wig/src

export VISUAL=vim
export EDITOR=vim
