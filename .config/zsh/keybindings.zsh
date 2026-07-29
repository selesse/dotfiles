# Use Vim key bindings to edit the current shell command
bindkey -v
bindkey jk vi-cmd-mode

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
