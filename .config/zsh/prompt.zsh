# vim: set ft=zsh:

autoload -Uz colors
colors
setopt PROMPT_SUBST


# Keep git status off the prompt path because large worktrees can make it expensive.
zmodload zsh/system
autoload -Uz add-zsh-hook

typeset -g ASELESSE_GIT_PROMPT=""
typeset -gi ASELESSE_GIT_PROMPT_FD=-1
typeset -gi ASELESSE_GIT_PROMPT_PID=-1

_aselesse_git_prompt_content() {
    emulate -L zsh
    local git_status line branch="" dirty=""

    git_status=$(GIT_OPTIONAL_LOCKS=0 command git status --porcelain=v2 --branch --ignore-submodules=dirty 2>/dev/null) || return
    for line in "${(@f)git_status}" ; do
        case "$line" in
            ("# branch.head "*) branch=${line#\# branch.head } ;;
            ([12u]\ *|\?\ *) dirty="*" ;;
        esac
    done

    if [[ -z "$branch" || "$branch" == "(detached)" ]] ; then
        branch=$(GIT_OPTIONAL_LOCKS=0 command git describe --tags --exact-match HEAD 2>/dev/null) || \
            branch=$(GIT_OPTIONAL_LOCKS=0 command git rev-parse --short HEAD 2>/dev/null) || return
    fi

    branch=${branch//\%/%%}
    print -rn -- "git:(${branch}${dirty})"
}

_aselesse_git_prompt_cancel() {
    local -i fd=$ASELESSE_GIT_PROMPT_FD
    local -i pid=$ASELESSE_GIT_PROMPT_PID

    if (( fd >= 0 )) ; then
        zle -F "$fd" 2>/dev/null
        exec {fd}<&-
    fi

    if (( pid > 0 )) ; then
        if [[ -o MONITOR ]] ; then
            kill -TERM -$pid 2>/dev/null
        else
            kill -TERM $pid 2>/dev/null
        fi
    fi

    ASELESSE_GIT_PROMPT_FD=-1
    ASELESSE_GIT_PROMPT_PID=-1
}

_aselesse_git_prompt_callback() {
    local -i fd=$1
    local error=$2 result=""

    if [[ -z "$error" || "$error" == "hup" ]] ; then
        IFS= read -r -u "$fd" -d '' result
        if [[ "$ASELESSE_GIT_PROMPT" != "$result" ]] ; then
            ASELESSE_GIT_PROMPT=$result
            zle .reset-prompt
            zle -R
        fi
    fi

    zle -F "$fd" 2>/dev/null
    exec {fd}<&-
    if (( ASELESSE_GIT_PROMPT_FD == fd )) ; then
        ASELESSE_GIT_PROMPT_FD=-1
        ASELESSE_GIT_PROMPT_PID=-1
    fi
}

_aselesse_git_prompt_request() {
    _aselesse_git_prompt_cancel

    local -i fd pid
    exec {fd}< <(
        print -r -- ${sysparams[pid]}
        _aselesse_git_prompt_content
    )
    if ! read -r -u "$fd" pid ; then
        exec {fd}<&-
        return
    fi

    ASELESSE_GIT_PROMPT_FD=$fd
    ASELESSE_GIT_PROMPT_PID=$pid
    zle -F "$fd" _aselesse_git_prompt_callback
}

add-zsh-hook precmd _aselesse_git_prompt_request

current_directory_max_length="50"
current_directory="[%{$fg[yellow]%}%${current_directory_max_length}<...<%~%<<%{$reset_color%}]"
last_exit_code_if_nonzero="%(?.. (%?%))"
number_of_background_jobs="%(1j. $fg[green]%j%{$reset_color%}.)"
prompt_character="%(!.#.$)"

battery() {
    local percentage=""
    if (( $+commands[pmset] )) ; then
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
RPROMPT='$(battery) ${ASELESSE_GIT_PROMPT}'

if [[ "$OSTYPE" != darwin* ]] ; then
    user_at_hostname="[%{$fg[red]%}%B%n%{$fg[white]%}@%{$fg[green]%}%m%{$fg[blue]%}%b%{$reset_color%}]"
    PROMPT="${user_at_hostname} ${PROMPT}"
fi
