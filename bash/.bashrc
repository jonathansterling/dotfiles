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

# Load this machine's private/local interactive config (functions, aliases).
# Provided by this machine's private dotfiles repo; absent on a fresh machine.
[ -r ~/.bashrc.local ] && source ~/.bashrc.local
