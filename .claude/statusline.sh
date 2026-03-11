#!/bin/bash
input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Colors (ANSI)
cyan="\033[36m"
green="\033[32m"
yellow="\033[33m"
magenta="\033[35m"
red="\033[31m"
reset="\033[0m"

# Worktree name: extract from ~/world/trees/<name>/src
worktree=""
if [[ "$cwd" =~ world/trees/([^/]+)/src ]]; then
  tree_name="${BASH_REMATCH[1]}"
  if [[ "$tree_name" != "root" ]]; then
    worktree="$tree_name"
  fi
fi

# Branch name
branch=""
if [[ -n "$cwd" ]]; then
  branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
fi

# PR number (from Graphite local state, no network call)
pr=""
if [[ -n "$branch" && -n "$cwd" ]] && command -v gt &>/dev/null; then
  pr=$(cd "$cwd" && gt log short 2>/dev/null | grep -F "$branch" | grep -o '#[0-9]*' | head -1)
fi

# Context window color: red if >=80%, yellow if >=50%, green otherwise
ctx_color="$green"
if [[ -n "$used_pct" ]]; then
  pct_int=${used_pct%.*}
  if [[ "$pct_int" -ge 80 ]]; then
    ctx_color="$red"
  elif [[ "$pct_int" -ge 50 ]]; then
    ctx_color="$yellow"
  fi
fi

# Build output
parts=()
[[ -n "$model" ]] && parts+=("${yellow}${model}${reset}")
[[ -n "$worktree" ]] && parts+=("${magenta}${worktree}${reset}")
[[ -n "$branch" ]] && parts+=("${cyan}${branch}${reset}")
[[ -n "$pr" ]] && parts+=("${green}PR ${pr}${reset}")
[[ -n "$used_pct" ]] && parts+=("${ctx_color}ctx ${used_pct}%${reset}")

# Join with separator
output=""
for i in "${!parts[@]}"; do
  [[ $i -gt 0 ]] && output+=" | "
  output+="${parts[$i]}"
done

echo -e "$output"
