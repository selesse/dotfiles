# aseles's custom zshell theme

# features:
# path is autoshortened to ~50 characters
# displays git status (if applicable in current folder)
# turns username green if superuser, otherwise it is red
# shows battery for mac

if [ $UID -eq 0 ]; then NCOLOR="green"; else NCOLOR="red"; fi

battery() {
  percentage=$(pmset -g batt | grep -Eo "[0-9]{1,3}%" || echo "")
  if [ -z "$percentage" ] ; then
    echo "Unknown"
  else
    if [ "${percentage%?}" -gt 80 ] ; then
      percentage="%{$fg[green]%}$percentage%%{$reset_color%}"
    elif [ "${percentage%?}" -gt 60 ] ; then
      percentage="%{$fg[yellow]%}$percentage%%{$reset_color%}"
    elif [ "${percentage%?}" -gt 40 ] ; then
      percentage="%{$fg[magenta]%}$percentage%%{$reset_color%}"
    elif [ "${percentage%?}" -gt 20 ] ; then
      percentage="%{$fg[red]%}$percentage%%{$reset_color%}"
    else
      percentage="%{$fg[blue]%}$percentage%%{$reset_color%}"
    fi
    echo $percentage
  fi
}

vpnc_status() {
    VPNC_STATUS=$(pgrep vpnc || echo "")
    if [ ! -z "$VPNC_STATUS" ] ; then
        echo "%{$fg[red]%}(VPN ON)%{$reset_color%}"
    fi
}

hostname=$(uname -s)
# prompt
if [ "$hostname" = "Darwin" ] ; then
  PROMPT='[%{$fg[yellow]%}%50<...<%~%<<%{$reset_color%}]%(?.. (%?%))%(1j. $fg[green]%j%{$reset_color%}.) %(!.#.$) '
  RPROMPT='$(vpnc_status) $(battery) $(git_prompt_info)'
else
  PROMPT='[%{$fg[$NCOLOR]%}%B%n%{$fg[white]%}@%{$fg[green]%}%m%{$fg[blue]%}%b%{$reset_color%}] [%{$fg[yellow]%}%50<...<%~%<<%{$reset_color%}]%(?.. (%?%)) %(!.#.$) '
  RPROMPT='$(vpnc_status) $(git_prompt_info)'
fi

# git theming
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}!"
ZSH_THEME_GIT_PROMPT_CLEAN=""
