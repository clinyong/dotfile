#!/bin/bash
# Git aliases and helper functions, sourced by .zshrc.
# 迁移自本机 ~/.shell_self_config/git;gcd 已删除(很少用),
# gcm 兼容 master/main 两种默认分支名。

alias gss='git status -s'
alias gdf='git diff'
alias gp='git push'
# gl: smart pull — 拉远端最新 commit 并保留本地历史(浅克隆下增量拉, 不收紧边界).
# - 浅克隆仓库: git fetch --deepen=1 拉远端最新 tip 并加深一层, 然后按本地与远端关系处理 ——
#     · 已是最新(本地含远端 tip)            → already up to date, 不动.
#     · 本地领先(远端是本地祖先, 无独立提交)→ already up to date, 不动.
#     · 本地落后(可 fast-forward)           → git merge --ff-only, 线性接上远端新 commit.
#     · 分叉(双方各有独立 commit)           → git rebase FETCH_HEAD, 本地 commit 线性接在远端之后.
#     · rebase 因浅克隆历史不足失败          → 提示 git fetch --deepen 后重试.
#   用 --deepen=1 而非 --depth=1: 前者只加深不收紧, 不会让已拉来的历史从 git log 消失.
#   工作区干净才执行; 有未提交改动则中止, 不会丢数据.
# - 完整克隆仓库: 普通 git pull --rebase, 透传所有参数.
gl() {
  if git rev-parse --is-shallow-repository >/dev/null 2>&1; then
    local ref remote fetched_short head_short fetch_head
    ref=$(git symbolic-ref --short HEAD 2>/dev/null)
    remote=$(git config "branch.${ref}.remote" 2>/dev/null)
    if [ -z "$remote" ] || [ -z "$ref" ]; then
      echo "gl: shallow repo but no upstream branch found, falling back to git pull --rebase" >&2
      git pull --rebase "$@"; return $?
    fi
    if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
      echo "gl: working tree dirty — commit/stash first, then re-run." >&2
      return 1
    fi
    git fetch --deepen=1 "$remote" "$ref" || return $?
    fetch_head=$(git rev-parse FETCH_HEAD)
    head_short=$(git rev-parse --short HEAD)
    fetched_short=$(git rev-parse --short "$fetch_head")
    if [ "$(git rev-parse HEAD)" = "$fetch_head" ]; then
      echo "gl: already up to date."
      return 0
    fi
    # 本地领先: 远端 tip 已是本地祖先 → 无需移动.
    if git merge-base --is-ancestor "$fetch_head" HEAD 2>/dev/null; then
      echo "gl: already up to date. (local ahead of $remote/$ref)"
      return 0
    fi
    # 本地落后: 可 fast-forward → 线性接上远端新 commit.
    if git merge-base --is-ancestor HEAD "$fetch_head" 2>/dev/null; then
      echo "gl: fast-forward → $remote/$ref ($fetched_short)"
      git merge --ff-only FETCH_HEAD || return $?
      return 0
    fi
    # 分叉: 本地与远端各有独立 commit → rebase 本地到远端之后(线性).
    echo "gl: diverged → rebase local onto $remote/$ref ($fetched_short)"
    if git rebase FETCH_HEAD; then
      echo "gl: rebase done. (HEAD now at $(git rev-parse --short HEAD))"
      return 0
    fi
    # rebase 失败: 多半因浅克隆缺少分叉所需的历史; 提示加深后再试.
    echo "gl: rebase failed (likely shallow history gap)." >&2
    echo "    Run: git fetch --deepen=50 $remote $ref   then re-run gl." >&2
    return 1
  else
    git pull --rebase "$@"
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
alias lg='lazygit'
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
