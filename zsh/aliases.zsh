# vim: set filetype=zsh:

# misc
alias ls="ls ${LS_OPTS}"
alias lt="ls -ltrh"
alias grepi="grep -i"
alias vim="vim -O"

# git
alias ggrep="git grep -B0 -A0"
alias ggrepi="ggrep --ignore-case"
alias gu="git stash && git pull && git stash pop || true"
