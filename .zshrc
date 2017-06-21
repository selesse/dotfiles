### oh-my-zsh {
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="aseles"

# Red dots are displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

plugins=(ssh-agent tmux vundle)

DISABLE_AUTO_UPDATE=true
source $ZSH/oh-my-zsh.sh
### }

### zsh {
setopt EXTENDEDGLOB
# Don't fail at the shell level if there's a glob failure. This is useful when
# doing stuff like $(git log -- */file-that-doesnt-exist-anymore).
unsetopt NOMATCH

PATH_DIRECTORIES=(
  $HOME/bin
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  /usr/local/bin
  /usr/local/sbin
)

for directory in $PATH_DIRECTORIES; do
  if [ -d "$directory" ]; then
    PATH+=":$directory"
  fi
done

# Use Vim key bindings to edit the current shell command
bindkey -v
bindkey jk vi-cmd-mode

# Execute a command if a particular program exists
if_program_installed() {
    program=$1
    shift
    which "$program" > /dev/null && eval $* || true
}
### }

### editor {
export VISUAL=vim
export EDITOR=vim
### }

### history {
HISTFILE="${ZDOTDIR:-$HOME}/.zhistory"       # The path to the history file.
HISTSIZE=10000                               # The maximum number of events to save in the internal history.
SAVEHIST=10000                               # The maximum number of events to save in the history file.

#
# Options
#

setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing non-existent history.
### }

### prompt {
case "$(uname -s)" in
  "Darwin")
    alias ls="ls -G"
    alias l="ls -GF"

    # use jdk 8 by default:
    # http://stackoverflow.com/questions/12757558/installed-java-7-on-mac-os-x-but-terminal-is-still-using-version-6#comment21605776_12757565
    export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

    # /usr/local/bin should take precedence over /usr/bin
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
    alias ls="ls --color"
    alias l="ls --color -F"
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'

    say() {
      espeak -s 120 "$@" > /dev/null 2>&1
    }

    # change the color of root
    PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME} - ${PWD}\007"'
    if_program_installed linuxlogo "linuxlogo -u"
  ;;
esac
### }

### aliases {
alias config="cd ~/git/dotfiles"

alias hisgrep="history | grep"
alias fname="find . -type f -name"
alias vi="vim"
alias duh="du -chs"
if_program_installed colordiff 'alias diff="colordiff -u"'
if_program_installed tree 'alias tree="tree -C"'
if_program_installed ccat 'alias cat="ccat --bg=dark"'

# Allow for environment-specific custom aliases/functions
[ -f "$HOME/.localrc" ] && source $HOME/.localrc
[ -f "$HOME/.mutt/gmail.muttrc" ] && alias email="mutt -F $HOME/.mutt/gmail.muttrc"
### }

### exports {
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
### }

### functions {
cd() {
  if [ -z "$@" ] ; then
    return
  fi
  builtin cd "$@" && ls
}

extract() {
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

psgrep() {
  ps aux |
  grep -v grep | #exclude this grep from the results
  grep "$@" -i --color=auto;
}

# Keep going up directories until you find "$file", or we reach root.
find_parent_file() {
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

gw() {
  # cd into the directory so you don't generate .gradle folders everywhere
  builtin cd `find_parent_file gradlew` && ./gradlew $*
  builtin cd -
}

precmd() {
  local tab_label=${PWD/${HOME}/\~} # use 'relative' path
  echo -ne "\e]2;${tab_label}\a" # set window title to full string
}

vif() {
    file=$({ git ls-files -oc --exclude-standard 2>/dev/null || find . -type f } | fzf)
    if [ ! -z "$file" ] ; then
        vim $file
    fi
}

pass() {
    lpass ls > /dev/null 2>&1

    if [[ -z "$LPASS_USER" ]] ; then
        # Zsh-specific way of reading into a variable, see
        # http://superuser.com/q/555874/363363
        read "?LastPass username? " LPASS_USER
    fi

    if [[ $? -ne 0 ]] ; then
		lpass login $LPASS_USER
    fi

    id=$(lpass ls | fzf | egrep -o "id: [0-9]+" | sed -e 's/id: //')

    # The ID might be empty (i.e. if we ctrl+c out of the selection)
    if [[ ! -z "$id" ]] ; then
        echo "Username:" $(lpass show --username $id)
        if [[ ! -z "$(lpass show --notes $id)" ]] ; then
            echo "Notes:" $(lpass show --notes $id)
        fi
        lpass show -c --password $id
        echo ""
        echo "The password for this account is now copied into your clipboard."
    fi
}
### }

### startup_commands {
ls

if [ -f ~/.fzf.zsh ] ; then
    source ~/.fzf.zsh
fi
