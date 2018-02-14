### oh-my-zsh {
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="aselesse"

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

for directory in $PATH_DIRECTORIES ; do
    if [ -d "$directory" ] ; then
        PATH+=":$directory"
    fi
done
typeset -U PATH

# Use Vim key bindings to edit the current shell command
bindkey -v
bindkey jk vi-cmd-mode

# Eval arbitrary code if a particular program exists
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
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
HOSTNAME_SHORT=$(hostname -s)
mkdir -p "${HOME}/.history/$(date +%Y/%m/%d)"
HISTFILE="${HOME}/.history/$(date +%Y/%m/%d)/$(date +%H.%M.%S)_${HOSTNAME_SHORT}_$$"
HISTSIZE=65536
SAVEHIST=$HISTSIZE

_load_all_shell_history() {
    # Save current history first
    fc -W $HISTFILE

    ALL_HISTORY="$HOME/.history/.all-history"
    [ -f "$ALL_HISTORY" ] && rm -f "$ALL_HISTORY"
    cat ~/.history/**/*(.) > "$ALL_HISTORY"
    # Load *all* shell histories
    fc -R "$ALL_HISTORY"

    _ALL_SHELL_HISTORY_LOADED=1
}

history_incremental_pattern_search_all_history() {
    _load_all_shell_history
    zle end-of-history
    zle history-incremental-pattern-search-backward
}

history_beginning_search_backward_all_history() {
    # We can't reload the entire shell history every time we call this function
    # because successive calls would reload the entire history. Instead, ensure
    # the *entire* shell history only ever gets loaded once.
    if [[ "$_ALL_SHELL_HISTORY_LOADED" != "1" ]] ; then
        _load_all_shell_history
    fi
    zle history-beginning-search-backward
}

bindkey '^R' history_incremental_pattern_search_all_history
bindkey -M isearch '^R' history-incremental-pattern-search-backward
bindkey '^[p' history_beginning_search_backward_all_history
bindkey '^[n' history-beginning-search-forward

zle -N history_incremental_pattern_search_all_history
zle -N history_beginning_search_backward_all_history
### }

### os-specific {
case "$(uname -s)" in
    "Darwin")
        alias ls="ls -G"
        alias l="ls -GF"

        # use jdk 8 by default:
        # http://stackoverflow.com/questions/12757558/installed-java-7-on-mac-os-x-but-terminal-is-still-using-version-6#comment21605776_12757565
        export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
        ;;
    *)
        alias ls="ls --color"
        alias l="ls --color -F"
        if_program_installed xclip 'alias pbcopy="xclip -selection clipboard"'
        if_program_installed xclip 'alias pbpaste="xclip -selection clipboard -o"'
        ;;
esac
### }

### aliases {
alias config="cd ~/git/dotfiles"
alias hisgrep="history | grep"
alias fname="find . -type f -name"
alias vi="vim"
if_program_installed colordiff 'alias diff="colordiff -u"'
if_program_installed tree 'alias tree="tree -C"'
if_program_installed ccat 'alias cat="ccat --bg=dark"'
if_program_installed vagrant 'alias vagrant-rebuild="vagrant destroy -f && vagrant up && vagrant ssh"'

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

# Keep going up directories until you find "$file", or we reach root.
find_parent_file() {
    local file="$1"
    local directory="$PWD"
    local starting_directory="$directory"
    local target=""

    if [ -z "$file" ] ; then
        echo "Please specify a file to find"
    fi

    while [ -d "$directory" ] && [ "$directory" != "/" ] ; do
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

# Open a file in Vim using a fuzzy-finder
vif() {
    file=$({ git ls-files -oc --exclude-standard 2>/dev/null || find . -type f } | fzf)
    if [ ! -z "$file" ] ; then
        vim $file
    fi
}

### }

### startup_commands {
ls
### }

### fzf {
if [ -f ~/.fzf.zsh ] ; then
    source ~/.fzf.zsh

    # The fzf shell bindings rewrite your ^R with "fzf-history-widget".
    # I like this widget, but I would like it to load my entire shell history
    # instead of just the current shell's history.
    if [[ "$(bindkey '^R' | cut -f2 -d' ')" == "fzf-history-widget" ]] ; then
        enhanced-fzf-history-widget() {
            _load_all_shell_history
            fzf-history-widget
        }
        zle     -N   enhanced-fzf-history-widget
        bindkey '^R' enhanced-fzf-history-widget
    fi
fi
### }
