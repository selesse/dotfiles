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
