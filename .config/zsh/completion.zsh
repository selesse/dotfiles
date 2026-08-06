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
    # Silence errors: concurrent shells starting at once (e.g. several terminal
    # tabs restoring together) race to recompile this file and one can lose,
    # which is harmless since compinit already loaded completions by this point.
    zcompile "$completion_dump_file" 2>/dev/null
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
