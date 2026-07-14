#!/bin/bash
# Git aliases and helper functions, sourced by .zshrc.
# 迁移自本机 ~/.shell_self_config/git;gcd 已删除(很少用),
# gcm 兼容 master/main 两种默认分支名。

alias gss='git status -s'
alias gdf='git diff'
alias gp='git push'
alias gl='git pull'
alias gco='git checkout'
alias gc='git commit'
alias gffs='git flow feature start'
alias gfhs='git flow hotfix start'
alias gb='git branch'
alias gsh='git stash'
alias gshp='git stash pop'
alias ga='git add'
alias glg='git log'
alias glg1='git lg1'
alias glg2='git lg2'
alias gr='git rebase'
alias gf='git fetch'
alias gm='git merge --no-ff'
alias gsu='git submodule update'
alias gmt='git mergetool'
alias gcp='git cherry-pick'
alias gcm='git checkout master 2>/dev/null || git checkout main'
alias grc='git rebase --continue'
alias grm='git rebase master'
alias grim='git rebase -i master'
alias gcl='git clone'

function delb() {
    git push origin --delete $1
    git branch -D $1
}

# git refetch and checkout local branch
function grco() {
    git checkout master
    git branch -D $1
    git pull
    git checkout $1
}

function del_all_local_branch() {
    git branch | grep -v "master" | xargs git branch -D
}


function git_recent_branches() {
    git branch --sort=-committerdate
}
