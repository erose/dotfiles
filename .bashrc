# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

### BEGIN DEFAULT (entries added automatically by Ubuntu) ###
# I've removed some default entries, but kept others that I liked (or was too scared to remove) around. Comments in this section might not be from me.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000000
HISTFILESIZE=2000000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

export GIT_PS1_SHOWCOLORHINTS=true
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1)\$ '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

### END DEFAULT (entries added automatically by Ubuntu) ###

### BEGIN CUSTOM ###

promptFunc() {
  # right before prompting for the next command, save the previous
  # command in a file.
  echo "$(date +%Y-%m-%d--%H-%M-%S) $(hostname) $PWD $(history 1)" >> ~/.full_history
}
PROMPT_COMMAND=promptFunc

alias list-installed='dpkg --get-selections | grep -v deinstall'
alias unswap='sudo swapoff -a && sudo swapon -a'

# Boo to __pycache__ and .pyc files!
export PYTHONDONTWRITEBYTECODE=1

source ~/.git-completion.bash

# Short aliases for common destinations.
alias r='cd ~/shearwater/mentorcollective-rails' # r for Rails
alias e='cd ~/shearwater/mentorcollective-ember' # e for Ember
alias b='cd ~/personal/site-generator && source venv/bin/activate' # b for blog
alias u='cd ~/personal/upload-music && source venv/bin/activate' # u for upload

alias gp='git pull --ff-only && (if_migrations_necessary || bundle exec rails db:migrate); git remote prune origin'
__git_complete gp _git_pull
alias gc='git checkout'
__git_complete gc _git_checkout
alias gd='git diff'
__git_complete gd _git_diff
alias gl='git --no-pager log --graph --decorate --pretty=oneline -n 20 --abbrev-commit --all'
alias gb='git branch'
alias gsu='git stash -u'
__git_complete gsu _git_stash
alias grc='git add --all && git rebase --continue'
alias gra='git rebase --abort'
alias gtp='bundle exec rails test && git push'
alias gbtr='git reset --soft HEAD^ && git reset' # 'git backtrack'
gcm() {
  git commit -m "$1"
}
gcmf(){
  gcm $(git-filler-commit-message)
}
gcma(){
  git add --all && git commit -m "$1"
}
gcman(){
  git add --all && git commit -m "$1" --no-verify
}
gcmaf(){
  gcma $(git-filler-commit-message)
}
gcmanf(){
  gcman $(git-filler-commit-message)
}
gbds(){
  git diff "$1" master --exit-code && git branch -d "$1"
}
__git_complete gbds _git_diff
gi(){
  # 'git integrate'
  if [[ -z $(git status -s) ]]; then
    gp && return
  fi
  git stash && gp && git stash pop
}
__git_complete gi _git_pull
git-filler-commit-message(){
  echo "Progress: $(date +%Y-%m-%d-%H:%M:%S)"
}

pr-clean(){
  _PREV_BRANCH=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)
  gc master && git branch -d $_PREV_BRANCH && gp
}
__git_complete pr-clean _git_checkout
alias s='git status'
alias lcm='git log -1 --pretty=%B'
eval "$(hub alias -s)" # Hub chooses the best way to alias itself to git.

current_branch() {
  git rev-parse --abbrev-ref HEAD
}
# In the current branch, how many commits do we have that aren't in the argument branch?
commits_ahead_of() {
  git rev-list $(current_branch) --not "$1" | wc -l
}

# Squash all commits on a feature branch down into one for easier rebasing.
alias sqfb='git reset --soft HEAD~$(commits_ahead_of master); git commit -n -m \"$(current_branch)\"'
squash_onto() {
  commits_ahead_of_target=$(commits_ahead_of "$1")
  git reset --soft HEAD~"$commits_ahead_of_target"; git commit -n -m \"$(current_branch)\"
}
__git_complete squash_onto _git_checkout

# Quickly measure the performance of a GET request.
function perf {
  curl -o /dev/null -s -w "%{time_connect} + %{time_starttransfer} = %{time_total}\n" "$1"
}

confirm(){
  read -p "$1 (y/n)?" choice
  case "$choice" in 
    y|Y ) true;;
    * ) false;;
  esac
}

# Repeat the given command n times.
repeat(){
  n=$1
  shift
  for i in `seq $n`; do
    $@
  done
}

whos-using-port(){
  lsof -i :$1
}

# IMPORTS
source ~/shearwater/dotfiles/.bashrc

### END CUSTOM ###

### BEGIN AUTOMATICALLY ADDED BY THIRD PARTIES (comments here might not be written by me) ###

# For RVM to work.
source ~/.rvm/scripts/rvm

# Hook to allow gnome-terminal to run commands when ~/.bashrc is loaded, e.g.
# BASH_POST_RC='command1; command2' gnome-terminal
# See http://superuser.com/questions/198015 for why this is necessary.
eval "$BASH_POST_RC"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# Added by Yarn, I assume. (Although they did not leave a comment.)
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

### END AUTOMATICALLY ADDED BY THIRD PARTIES ###
