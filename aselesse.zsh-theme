# vim: set ft=zsh:
GITSTATUS_DIR="$HOME/git/gitstatus"
gitstatus_plugin_file="$GITSTATUS_DIR/gitstatus.plugin.zsh"
current_directory_max_length="50"
current_directory="[%{$fg[yellow]%}%${current_directory_max_length}<...<%~%<<%{$reset_color%}]"
last_exit_code_if_nonzero="%(?.. (%?%))"
number_of_background_jobs="%(1j. $fg[green]%j%{$reset_color%}.)"
prompt_character="%(!.#.$)"

if [[ -f "$gitstatus_plugin_file" ]] ; then
    source "$gitstatus_plugin_file"
    GITSTATUS_ENABLED="true"
fi

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

aselesse_git_prompt() {
    if [[ "$GITSTATUS_ENABLED" == true ]] ; then
        if gitstatus_query "MY" ; then
            if ! [[ $VCS_STATUS_RESULT == 'ok-sync' ]] ; then
                RPROMPT="$(battery)"
                return
            fi
            RPROMPT=${${VCS_STATUS_LOCAL_BRANCH:-@${VCS_STATUS_COMMIT}}//\%/%%}  # escape %
            (( $VCS_STATUS_NUM_STAGED    )) && RPROMPT+='+'
            (( $VCS_STATUS_NUM_UNSTAGED  )) && RPROMPT+='!'
            (( $VCS_STATUS_NUM_UNTRACKED )) && RPROMPT+='?'
            local p

            local where  # branch name, tag or commit
            if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
                where=$VCS_STATUS_LOCAL_BRANCH
            elif [[ -n $VCS_STATUS_TAG ]]; then
                p+='%f#'
                where=$VCS_STATUS_TAG
            else
                p+='%f@'
                where=${VCS_STATUS_COMMIT[1,8]}
            fi

            p+="${clean}${where//\%/%%}"             # escape %

            # ⇣42 if behind the remote.
            (( VCS_STATUS_COMMITS_BEHIND )) && p+=" ${clean}⇣${VCS_STATUS_COMMITS_BEHIND}"
            # ⇡42 if ahead of the remote; no leading space if also behind the remote: ⇣42⇡42.
            (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && p+=" "
            (( VCS_STATUS_COMMITS_AHEAD  )) && p+="${clean}⇡${VCS_STATUS_COMMITS_AHEAD}"
            # ⇠42 if behind the push remote.
            (( VCS_STATUS_PUSH_COMMITS_BEHIND )) && p+=" ${clean}⇠${VCS_STATUS_PUSH_COMMITS_BEHIND}"
            (( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && p+=" "
            # ⇢42 if ahead of the push remote; no leading space if also behind: ⇠42⇢42.
            (( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && p+="${clean}⇢${VCS_STATUS_PUSH_COMMITS_AHEAD}"
            # *42 if have stashes.
            (( VCS_STATUS_STASHES        )) && p+=" ${clean}*${VCS_STATUS_STASHES}"
            # 'merge' if the repo is in an unusual state.
            [[ -n $VCS_STATUS_ACTION     ]] && p+=" ${conflicted}${VCS_STATUS_ACTION}"
            # ~42 if have merge conflicts.
            (( VCS_STATUS_NUM_CONFLICTED )) && p+=" ${conflicted}~${VCS_STATUS_NUM_CONFLICTED}"
            # +42 if have staged changes.
            (( VCS_STATUS_NUM_STAGED     )) && p+=" ${modified}+${VCS_STATUS_NUM_STAGED}"
            # !42 if have unstaged changes.
            (( VCS_STATUS_NUM_UNSTAGED   )) && p+=" ${modified}!${VCS_STATUS_NUM_UNSTAGED}"
            # ?42 if have untracked files. It's really a question mark, your font isn't broken.
            (( VCS_STATUS_NUM_UNTRACKED  )) && p+=" ${untracked}?${VCS_STATUS_NUM_UNTRACKED}"
            RPROMPT="$(battery) %{$fg[magenta]%}${p}%{$reset_color%}"
        fi

        setopt noprompt{bang,subst} promptpercent  # enable/disable correct prompt expansions
    fi
}

PROMPT="${current_directory}${last_exit_code_if_nonzero}${number_of_background_jobs} ${prompt_character} "

if [[ "$GITSTATUS_ENABLED" == true ]] ; then
    gitstatus_stop 'MY' && gitstatus_start -s -1 -u -1 -c -1 -d -1 'MY'
    autoload -Uz add-zsh-hook
    add-zsh-hook precmd aselesse_git_prompt
else
    RPROMPT='$(battery) $(git_prompt_info)'
fi

if [[ $(uname -s) != "Darwin" ]] ; then
    user_at_hostname="[%{$fg[red]%}%B%n%{$fg[white]%}@%{$fg[green]%}%m%{$fg[blue]%}%b%{$reset_color%}]"
    PROMPT="${user_at_hostname} ${PROMPT}"
fi


