# ENVIRONMENT VARIABLES #
#########################

# No brainer, default to Vim
export EDITOR="vim"

# Color LS output to differentiate between directories and files
export LS_OPTIONS="--color=auto"
export CLICOLOR="Yes"
export LSCOLOR=""

# Setup PATH to use /usr/local first so Homebrew installs
# are used instead of system installs
export PATH=$HOME/bin:/usr/local/bin:/usr/local/share/python:$PATH

# ALIASES #
###########

# Standard Shell
alias c='clear'
alias l='ls -l'
alias la='ls -al'

# Git
alias g='git status -s'
alias gb='git branch'
alias gba='git branch -a'
alias gc='git commit -m'
alias gca='git commit -am'
alias gco='git checkout'
alias gcob='git checkout -b'

# tmux
alias start='tmuxinator start'
alias attach='tmux attach-session -t'
alias switch='tmux switch-session -t'
alias tmk='tmux kill-session -t'

# Django
alias pm='python manage.py'

# Ruby REPL's
alias irb='irb --simple-prompt'
alias pry='pry --simple-prompt'

# ZSH CONFIGURATION #
#####################

# Turn off Vi mode
bindkey -e

# Allow rbenv if it's installed (which it should be!)
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Source Tmuxinator if installed
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

# Virtualenv & Virtualenvwrapper setup if installed
VIRTUAL_ENV_DISABLE_PROMPT=1
if which virtualenv > /dev/null;
then
  VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
  export WORKON_HOME=$HOME/.virtualenvs
  source /usr/local/share/python/virtualenvwrapper.sh
  export PIP_VIRTUALENV_BASE=$WORKON_HOME
fi

# Load completions for Ruby, Git, etc.
autoload compinit && compinit -C

# Case insensitive auto-complete
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# PROMPT FUNCTIONS AND SETTINGS #
#################################

# Colors
autoload -U colors && colors
setopt prompt_subst

# Display Virtualenv cleanly in right column
function virtualenv_info {
  [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

# Display Rbenv cleanly if Rbenv is installed
function rbenv_info {
  if which rbenv > /dev/null; then echo "$(rbenv version-name)"; fi
}

# Show previous command status
local command_status="%(?,%{$fg[green]%}✔%{$reset_color%},%{$fg[red]%}✘%{$reset_colors%})"

# Show relative path on one line, then command status
PROMPT='
%{$fg[cyan]%}%n %{$fg[white]%}: %{$fg[cyan]%}%~ %{$fg[white]%}
${command_status} %{$reset_color%} '

# Show virtualenv, rbenv, branch, sha, and repo dirty status on right side
RPROMPT='%{$fg[cyan]%}$(virtualenv_info)%{$fg[white]%}$(rbenv_info)$(~/bin/git-cwd-info.sh)%{$reset_colors%}'
