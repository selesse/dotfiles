# modified mh theme
# preview: http://cl.ly/1y2x0W0E3t2C0F29043z

# features:
# path is autoshortened to ~50 characters
# displays git status (if applicable in current folder)
# turns username green if superuser, otherwise it is white

# if superuser make the username green
if [ $UID -eq 0 ]; then NCOLOR="green"; else NCOLOR="red"; fi

hostname=`uname -s`
# prompt
if [ "$hostname" = "Darwin" ] ; then
  PROMPT='[%{$fg[yellow]%}%50<...<%~%<<%{$reset_color%}]%(?.. (%?%)) %(!.#.$) '
else
  PROMPT='[%{$fg[$NCOLOR]%}%B%n%{$fg[white]%}@%{$fg[green]%}%m%{$fg[blue]%}%b%{$reset_color%}] [%{$fg[yellow]%}%50<...<%~%<<%{$reset_color%}]%(?.. (%?%)) %(!.#.$) '
fi
RPROMPT='$(git_prompt_info)'

# git theming
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}!"
ZSH_THEME_GIT_PROMPT_CLEAN=""
