#!/usr/bin/env bash

dir=${1:-$PWD}
pane_pid=$2
max_length=24

pane_runs_claude() {
  local root=$1 depth=0
  local -a frontier=("$root")

  while [ "${#frontier[@]}" -gt 0 ] && [ "$depth" -lt 6 ]; do
    local -a next=()
    for pid in "${frontier[@]}"; do
      [ "$(ps -p "$pid" -o comm=)" = "claude" ] && return 0
      while IFS= read -r child; do
        [ -n "$child" ] && next+=("$child")
      done < <(pgrep -P "$pid" 2>/dev/null)
    done
    frontier=("${next[@]}")
    depth=$((depth + 1))
  done

  return 1
}

[ -n "$pane_pid" ] && ! pane_runs_claude "$pane_pid" && exit 0

truncate_name() {
  local name=$1
  if [ "${#name}" -gt "$max_length" ]; then
    printf '%s..' "${name:0:max_length}"
  else
    printf '%s' "$name"
  fi
}

raw=$(git -C "$dir" rev-parse --path-format=absolute --abbrev-ref HEAD --show-toplevel --git-dir --git-common-dir 2>/dev/null) || exit 0

readarray -t lines <<< "$raw"
branch=${lines[0]}
toplevel=${lines[1]}
git_dir=${lines[2]}
common_dir=${lines[3]}

color=46
label=$(truncate_name "$branch")

if [ "$git_dir" != "$common_dir" ]; then
  color=214
  wt_name=$(basename "$toplevel")
  if [ "$wt_name" != "$branch" ]; then
    label="$(truncate_name "$wt_name") → $(truncate_name "$branch")"
  fi
fi

display=${dir/#$HOME/\~}

if [[ "$display" == "~/worktrees/"* ]]; then
  rest=${display#"~/worktrees/"}
  IFS='/' read -r -a parts <<< "$rest"
  if [ "${#parts[@]}" -gt 2 ]; then
    kept=("${parts[@]:2}")
    display="…/$(IFS=/; echo "${kept[*]}")"
  fi
fi

printf '#[fg=white][#[fg=colour%s]%s#[fg=white]]#[fg=colour253] %s' "$color" "$label" "$display"
