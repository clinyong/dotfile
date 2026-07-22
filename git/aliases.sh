#!/bin/bash
# Git aliases and helper functions, sourced by .zshrc.
# 迁移自本机 ~/.shell_self_config/git;gcd 已删除(很少用),
# gcm 兼容 master/main 两种默认分支名。

alias gss='git status -s'
alias gdf='git diff'
alias gp='git push'
# gl: smart pull.
# - 浅克隆仓库: 浅拉当前分支 tip 并对齐(避免 fetch 全量历史).
#   工作区干净才执行 reset --hard; 有未提交改动则中止, 不会丢数据.
# - 完整克隆仓库: 普通 git pull, 透传所有参数.
gl() {
  if git rev-parse --is-shallow-repository >/dev/null 2>&1; then
    local ref remote
    ref=$(git symbolic-ref --short HEAD 2>/dev/null)
    remote=$(git config "branch.${ref}.remote" 2>/dev/null)
    if [ -z "$remote" ] || [ -z "$ref" ]; then
      echo "gl: shallow repo but no upstream branch found, falling back to git pull" >&2
      git pull "$@"; return $?
    fi
    if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
      echo "gl: working tree dirty — commit/stash first, then re-run." >&2
      return 1
    fi
    git fetch --depth=1 "$remote" "$ref" || return $?
    if [ "$(git rev-parse HEAD)" = "$(git rev-parse FETCH_HEAD)" ]; then
      echo "gl: already up to date."
      return 0
    fi
    echo "gl: shallow sync → reset --hard to $remote/$ref ($(git rev-parse --short FETCH_HEAD))"
    git reset --hard FETCH_HEAD
  else
    git pull "$@"
  fi
}
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
