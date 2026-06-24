#-------------------
# Personal Settings
#-------------------

[[ -s ~/.bashrc ]] && source ~/.bashrc

# Prompt
PS1='[\[\e[38;5;46m\]$(get_truncated_git_branch)\[\e[0m\]] \w > '

#---------------
# Environment
#---------------

# Silence zsh warning
export BASH_SILENCE_DEPRECATION_WARNING=1

# ls colors
export CLICOLOR=1
export LSCOLORS=exfxcxdxbxegedabagacad

# spotify themes
export PATH="$HOME/.spicetify:$PATH"

#---------------
# Aliases
#---------------

alias bp="nvim ~/.bash_profile"
alias brc="nvim ~/.bashrc"
alias gitlog="git log --pretty=format:\"%h%x09%an%x09%ad%x09%s\""
alias python="python3"
alias py="python3"
alias notepad="nvim ~/Documents/notes/tmp.txt"
alias todo="nvim ~/Documents/notes/TODO.md"
alias journal="nvim ~/Documents/notes/journal.txt"

#---------------
# Tools
#---------------

[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"
[ -r "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

#---------------
# Local / private (per-machine)
#---------------

# Load this machine's private/local login config (PATH, env, tool init).
# Provided by this machine's private dotfiles repo; absent on a fresh machine.
[ -r ~/.bash_profile.local ] && source ~/.bash_profile.local
