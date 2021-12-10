PATH_DIRECTORIES=(
    $HOME/bin
    /usr/bin
    /bin
    /usr/sbin
    /sbin
    /usr/local/bin
    /usr/local/sbin
    /opt/homebrew/bin
    /opt/homebrew/sbin
)

for directory in $PATH_DIRECTORIES ; do
    if [ -d "$directory" ] ; then
        PATH+=":$directory"
    fi
done
typeset -U PATH

# Eval arbitrary code if a particular program exists
if_program_installed() {
    program=$1
    shift
    which "$program" > /dev/null && eval $* || true
}

export VISUAL=vim
export EDITOR="$VISUAL"
if_program_installed nvim 'export VISUAL=nvim'
if_program_installed nvim 'export EDITOR="$VISUAL"'

if_program_installed fd 'export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git --exclude \"*.rbi\""'
