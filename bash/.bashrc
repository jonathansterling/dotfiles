# vi navigation
set -o vi

# Load secrets / env (untracked, not in any repo)
[[ -f ~/.env ]] && source ~/.env

# Truncate a prompt component (branch/worktree name) to a max length.
__truncate_prompt_name() {
  local name=$1 max=24
  if [ "${#name}" -gt "$max" ]; then
    printf '%s..' "${name:0:max}"
  else
    printf '%s' "$name"
  fi
}

# Build the colored "[branch]" or "[worktree -> branch]" prompt segment.
# Color signals whether the current directory is a linked worktree.
git_prompt_segment() {
  local raw
  raw=$(git rev-parse --path-format=absolute --abbrev-ref HEAD --show-toplevel --git-dir --git-common-dir 2>/dev/null) || return

  local -a lines
  readarray -t lines <<< "$raw"
  local branch=${lines[0]} toplevel=${lines[1]} git_dir=${lines[2]} common_dir=${lines[3]}

  local color=46
  local label
  label=$(__truncate_prompt_name "$branch")

  if [ "$git_dir" != "$common_dir" ]; then
    color=214
    local wt_name
    wt_name=$(basename "$toplevel")
    if [ "$wt_name" != "$branch" ]; then
      label="$(__truncate_prompt_name "$wt_name") → $(__truncate_prompt_name "$branch")"
    fi
  fi

  printf '\001\033[38;5;%sm\002%s\001\033[0m\002' "$color" "$label"
}

# Print the current directory for the prompt, collapsing the
# ~/worktrees/<host>/<org>/... prefix that this machine's worktree tool uses
# down to just the repo and worktree name.
__prompt_path() {
  local display=${PWD/#$HOME/\~}

  if [[ "$display" == "~/worktrees/"* ]]; then
    local rest=${display#"~/worktrees/"}
    local -a parts
    IFS='/' read -r -a parts <<< "$rest"
    if [ "${#parts[@]}" -gt 2 ]; then
      local kept=("${parts[@]:2}")
      display="…/$(IFS=/; echo "${kept[*]}")"
    fi
  fi

  printf '%s' "$display"
}

gcp() {
  git cherry-pick "$1"
}

cleangitbranches() {
  git branch | grep -v "master" | xargs git branch -D
}

postgresport() {
  sudo lsof -i -P | grep LISTEN | grep :5432
}

claude() {
  if [[ "$PWD" == "$HOME/Projects/jon" || "$PWD" == "$HOME/Projects/jon/"* ]]; then
    CLAUDE_CONFIG_DIR="$HOME/.claude-personal" command claude "$@"
  else
    command claude "$@"
  fi
}

claude-personal() {
  CLAUDE_CONFIG_DIR="$HOME/.claude-personal" command claude "$@"
}

# Load this machine's private/local interactive config (functions, aliases).
# Provided by this machine's private dotfiles repos (e.g. dotfiles-pattern,
# dotfiles-karefirst); absent on a fresh machine. Multiple repos can each
# contribute a ~/.bashrc.<repo>.local file and all get sourced.
for local_bashrc in ~/.bashrc.*.local; do
  [ -r "$local_bashrc" ] && source "$local_bashrc"
done
unset local_bashrc
. "$HOME/.cargo/env"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# gwq bash
source <(gwq completion bash)
