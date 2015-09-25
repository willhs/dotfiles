# Use `hub` as our git wrapper:
#   http://defunkt.github.com/hub/
hub_path=$(which hub)
if (( $+commands[hub] ))
then
  alias git=$hub_path
fi

# Will's added
alias gpull="git pull"

# The rest of holman's fun git aliases
# git plugin for ohmyzsh conflicts with the ones i commented out

#alias gl='git pull --prune'
#alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
#alias gp='git push origin HEAD'
#alias gd='git diff'
#alias gc='git commit'
#alias gca='git commit -a'
#alias gco='git checkout'
#alias gcb='git copy-branch-name'
#alias gb='git branch'
alias gs='git status -sb' # upgrade your git if -sb breaks for you. it's fun.
