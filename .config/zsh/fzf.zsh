if [ -f ~/.fzf.zsh ] ; then
    source ~/.fzf.zsh
fi

FZF_PREVIEW_BINDINGS="--bind page-up:preview-page-up,page-down:preview-page-down"
AUTOCOMPLETE_FZF_OPTIONS="--height ${FZF_TMUX_HEIGHT:-60%} ${FZF_PREVIEW_BINDINGS} ${FZF_DEFAULT_OPTS} -n2..,.. \
      --tiebreak=index $FZF_CTRL_R_OPTS +m"

git_autocomplete() {
  local selected preview_bindings
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
  selected=$(run_selection_program $LBUFFER)
  LBUFFER="${LBUFFER}${selected}"
  local ret=$?
  zle reset-prompt
  return $ret
}

run_selection_program() {
  buffer=$1
  if [[ $buffer =~ "git rebase" ]] || [[ $buffer =~ "git commit --fixup" ]]; then
    git list-branch-commits | run_fzf_with_preview "git show {}"
  elif [[ $buffer =~ "git add" ]] || [[ $buffer =~ "git reset" ]] ; then
    { git diff --name-only; git diff --name-only --staged; git ls-files --others --exclude-standard; } | \
      run_fzf_with_preview "git ls-files --error-unmatch 2> /dev/null {} && git diff {} || git diff --no-index /dev/null {}"
  elif [[ $buffer =~ "git co" ]] ; then
      git diff --name-only | run_fzf_with_preview "git diff {}"
  else
    git list-branch-commits | run_fzf_with_preview "git show {}"
  fi
}

run_fzf_with_preview() {
  FZF_DEFAULT_OPTS=${AUTOCOMPLETE_FZF_OPTIONS} fzf --preview="$1"
}

zle     -N   git_autocomplete
bindkey '^G' git_autocomplete

fuzzy_select_projects() {
  project=$(ff -p)
  if [ -n "$project" ] ; then
    echo "cd $project"
    builtin cd $project && ls
    zle reset-prompt
  fi
}

zle     -N   fuzzy_select_projects
bindkey '^P' fuzzy_select_projects

ff_widget() {
  local selected
  selected=$(ff)
  if [ -n "$selected" ] ; then
    LBUFFER="${LBUFFER}${selected}"
  fi
  zle reset-prompt
}

zle     -N   ff_widget
bindkey '^F' ff_widget
