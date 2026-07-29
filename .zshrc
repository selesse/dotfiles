zsh_config_home="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

source "$zsh_config_home/options.zsh"
source "$zsh_config_home/history.zsh"
source "$zsh_config_home/completion.zsh"
source "$zsh_config_home/prompt.zsh"
source "$zsh_config_home/aliases.zsh"

[ -f "$HOME/.localrc" ] && source "$HOME/.localrc"
[ -f "$HOME/.mutt/gmail.muttrc" ] && alias email="mutt -F $HOME/.mutt/gmail.muttrc"

source "$zsh_config_home/functions.zsh"
source "$zsh_config_home/keybindings.zsh"

ls
source "$zsh_config_home/fzf.zsh"
unset zsh_config_home
