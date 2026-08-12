# vi navigation
set -o vi

# Load secrets / env (untracked, not in any repo)
[[ -f ~/.env ]] && source ~/.env

# Function to get the current Git branch name and truncate it if necessary
get_truncated_git_branch() {
  local branch_name=$(git symbolic-ref --short HEAD 2>/dev/null)
  local max_length=24

  if [ -n "$branch_name" ]; then
    if [ ${#branch_name} -gt $max_length ]; then
      echo "${branch_name:0:max_length}.."
    else
      echo "$branch_name"
    fi
  fi
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
