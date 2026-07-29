### zsh {
setopt EXTENDEDGLOB
setopt AUTO_CD
setopt AUTO_PUSHD
setopt INTERACTIVE_COMMENTS
setopt LONG_LIST_JOBS
setopt MULTIOS
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS

# Don't fail at the shell level if there's a glob failure. This is useful when
# doing stuff like $(git log -- */file-that-doesnt-exist-anymore).
unsetopt FLOW_CONTROL
unsetopt NOMATCH

WORDCHARS=""
export PAGER="${PAGER:-less}"
export LESS="${LESS:--R}"

# Use Vim key bindings to edit the current shell command
bindkey -v
bindkey jk vi-cmd-mode
### }

### history {
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY
### }

### completion {
fpath=(${fpath:#$HOME/.oh-my-zsh/*})
typeset -U fpath

completion_cache_directory="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
completion_dump_file="$completion_cache_directory/zcompdump-$ZSH_VERSION"
if [[ ! -d "$completion_cache_directory/completions" ]]; then
    command mkdir -p "$completion_cache_directory/completions"
fi

zmodload -i zsh/complist
autoload -Uz compinit
if [[ ! -r "$completion_dump_file" || -n "$completion_dump_file"(#qN.mh+24) ]]; then
    compinit -d "$completion_dump_file"
else
    compinit -C -d "$completion_dump_file"
fi
if [[ ! -r "$completion_dump_file.zwc" || "$completion_dump_file" -nt "$completion_dump_file.zwc" ]]; then
    zcompile "$completion_dump_file"
fi

unsetopt MENU_COMPLETE
setopt AUTO_MENU
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$completion_cache_directory/completions"
zstyle '*' single-ignored show
unset completion_cache_directory completion_dump_file
### }

### prompt {
autoload -Uz colors
colors
setopt PROMPT_SUBST
source "${${(%):-%x}:A:h}/aselesse.zsh-theme"
### }

### os-specific {
case "$(uname -s)" in
    "Darwin")
        alias ls="ls -G"
        alias l="ls -GF"

        export JAVA_HOME=$(/usr/libexec/java_home)
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
alias vi="${EDITOR}"
if_program_installed colordiff 'alias diff="colordiff -u"'
if_program_installed tree 'alias tree="tree -C"'
if_program_installed bat 'alias cat="bat"'
if_program_installed vagrant 'alias vagrant-rebuild="vagrant destroy -f && vagrant up && vagrant ssh"'

# Allow for environment-specific custom aliases/functions
[ -f "$HOME/.localrc" ] && source $HOME/.localrc
[ -f "$HOME/.mutt/gmail.muttrc" ] && alias email="mutt -F $HOME/.mutt/gmail.muttrc"
### }

### exports {
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
export LS_COLORS="di=1;34:ln=1;36:so=1;31:pi=1;33:ex=1;32:bd=1;34;46:cd=1;34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
### }

### functions {
chpwd() {
    [[ -o interactive ]] && ls
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
    file=$(fzf)
    if [ ! -z "$file" ] ; then
        $EDITOR $file
    fi
}
### }

# Fix home/end key bindings that are somehow broken by Zsh
if [ -n "$ZSH_VERSION" ] ; then
    # If you wanna see what key to bind, hit ctrl+v then the key on your keyboard
    bindkey 'OH' beginning-of-line
    bindkey 'OF' end-of-line
    bindkey '^[[3~' delete-char
    bindkey '^[[5~' up-line-or-history
    bindkey '^[[A' up-line-or-search
    bindkey '^[[B' down-line-or-search
    bindkey '^[[6~' down-line-or-history
fi

### startup_commands {
ls
### }

### fzf {
if [ -f ~/.fzf.zsh ] ; then
    source ~/.fzf.zsh
fi

FZF_PREVIEW_BINDINGS="--bind page-up:preview-page-up,page-down:preview-page-down"
AUTOCOMPLETE_FZF_OPTIONS="--height ${FZF_TMUX_HEIGHT:-60%} ${FZF_PREVIEW_BINDINGS} ${FZF_DEFAULT_OPTS} -n2..,.. \
      --tiebreak=index $FZF_CTRL_R_OPTS +m"

git_autocomplete() {
  local selected preview_bindings
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
  selected=$(run_selection_program $LBUFFER)
  LBUFFER="${LBUFFER}${selected}"
  local ret=$?
  zle reset-prompt
  return $ret
}

run_selection_program() {
  buffer=$1
  if [[ $buffer =~ "git rebase" ]] || [[ $buffer =~ "git commit --fixup" ]]; then
    git list-branch-commits | run_fzf_with_preview "git show {}"
  elif [[ $buffer =~ "git add" ]] || [[ $buffer =~ "git reset" ]] ; then
    { git diff --name-only; git diff --name-only --staged; git ls-files --others --exclude-standard; } | \
      run_fzf_with_preview "git ls-files --error-unmatch 2> /dev/null {} && git diff {} || git diff --no-index /dev/null {}"
  elif [[ $buffer =~ "git co" ]] ; then
      git diff --name-only | run_fzf_with_preview "git diff {}"
  else
    git list-branch-commits | run_fzf_with_preview "git show {}"
  fi
}

run_fzf_with_preview() {
  FZF_DEFAULT_OPTS=${AUTOCOMPLETE_FZF_OPTIONS} fzf --preview="$1"
}

zle     -N   git_autocomplete
bindkey '^G' git_autocomplete

fuzzy_select_projects() {
  project=$(ff -p)
  if [ -n "$project" ] ; then
    echo "cd $project"
    builtin cd $project && ls
    zle reset-prompt
  fi
}

zle     -N   fuzzy_select_projects
bindkey '^P' fuzzy_select_projects

ff_widget() {
  local selected
  selected=$(ff)
  if [ -n "$selected" ] ; then
    LBUFFER="${LBUFFER}${selected}"
  fi
  zle reset-prompt
}

zle     -N   ff_widget
bindkey '^F' ff_widget
### }
