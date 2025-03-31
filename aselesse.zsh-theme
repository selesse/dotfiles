# vim: set ft=zsh:
current_directory_max_length="50"
current_directory="[%{$fg[yellow]%}%${current_directory_max_length}<...<%~%<<%{$reset_color%}]"
last_exit_code_if_nonzero="%(?.. (%?%))"
number_of_background_jobs="%(1j. $fg[green]%j%{$reset_color%}.)"
prompt_character="%(!.#.$)"

battery() {
    if which pmset > /dev/null ; then
        percentage=$(pmset -g batt | grep -Eo "[0-9]{1,3}%" || echo "")
    fi

    if [ -z "$percentage" ] ; then
        echo ""
    else
        local battery_color=""
        if [ "${percentage%?}" -gt 80 ] ; then
            battery_color="green"
        elif [ "${percentage%?}" -gt 60 ] ; then
            battery_color="yellow"
        elif [ "${percentage%?}" -gt 40 ] ; then
            battery_color="magenta"
        elif [ "${percentage%?}" -gt 20 ] ; then
            battery_color="red"
        else
            battery_color="blue"
        fi
        percentage="%{$fg[$battery_color]%}${percentage}%%{$reset_color%}"
        echo " $percentage"
    fi
}

PROMPT="${current_directory}${last_exit_code_if_nonzero}${number_of_background_jobs} ${prompt_character} "
RPROMPT='$(battery) $(git_prompt_info)'

if [[ $(uname -s) != "Darwin" ]] ; then
    user_at_hostname="[%{$fg[red]%}%B%n%{$fg[white]%}@%{$fg[green]%}%m%{$fg[blue]%}%b%{$reset_color%}]"
    PROMPT="${user_at_hostname} ${PROMPT}"
fi
