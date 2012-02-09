# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ `uname -s` == "Darwin" ] ; then
    # mac specific things

    # aliases 
    alias dropbox="cd ~/Dropbox/Public"
    alias school="cd ~/Dropbox/McGill"
    alias os="cd ~/Dropbox/McGill/OS"
    alias ai="cd ~/Dropbox/McGill/AI"
    alias 360="cd ~/Dropbox/McGill/COMP360"
    alias db="cd ~/Dropbox/McGill/Database"
    alias dp="cd ~/Dropbox/McGill/DP"
    alias ls="ls -G"
    alias l="ls -GF"
    PS1="[\[\e[1;32m\]\w\[\e[m\]] > "
else
    # linux specific things
    alias ls="ls --color"
    alias l="ls --color -F"
    PS1='[\[\e[1;32m\]\u\[\e[m\]@\[\e[1;31m\]\h\[\e[m\]][\[\e[1;34m\]\w\[\e[m\]] > '
fi

PATH=$PATH":./"
export EDITOR=vim;

# aliases for ssh
alias ubuntu="ssh aseles1@ubuntu.cs.mcgill.ca"
alias mimi="ssh aseles1@mimi.cs.mcgill.ca"
alias selerver="ssh alex@selesse.com"
alias swmud="telnet swmud.org 6666"
alias mq="ssh merqumab@sunnysuba.com -p 2222"

# function for cd
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
