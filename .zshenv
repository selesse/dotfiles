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

# mise shims, ahead of the system tools, so scripts and IDE builds see mise's
# versions where `mise activate` isn't running (see .zshrc).
if [ -d "$HOME/.local/share/mise/shims" ] ; then
    PATH="$HOME/.local/share/mise/shims:$PATH"
fi

# Eval arbitrary code if a particular program exists
if_program_installed() {
    program=$1
    shift
    which "$program" > /dev/null && eval $* || true
}

export VISUAL=nvim
export EDITOR="$VISUAL"
if_program_installed nvim 'alias vim=nvim'

if_program_installed fd 'export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git --exclude \"*.rbi\""'
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/ripgreprc"
