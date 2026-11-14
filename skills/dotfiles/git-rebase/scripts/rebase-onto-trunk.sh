#!/usr/bin/env bash
# Rebase the current branch onto remote trunk.
# Round-trips staged, unstaged, and untracked work via stash -u.
# Does not stash ignored files. Does not push.
set -u

print() { printf '%s\n' "$*"; }

die() {
  print "ERROR: $*"
  exit 1
}

stash_ref() {
  git stash list --format='%gd %gs' | awk -v t="$STASH_TOKEN" 'index($0, t) { print $1; exit }'
}

restore_stash() {
  if [[ "$STASHED" != "yes" ]]; then
    print "STASH_RESTORED=n/a"
    return 0
  fi

  local ref
  ref="$(stash_ref)"
  if [[ -z "$ref" ]]; then
    print "STASH_RESTORED=no"
    print "ERROR: stash token not found in git stash list: ${STASH_TOKEN}"
    return 1
  fi

  # apply --index once, then drop. Do not retry apply/pop: a failed --index
  # may already have restored the working tree, and a second apply duplicates work.
  if git stash apply --index "$ref"; then
    if git stash drop "$ref"; then
      print "STASH_RESTORED=yes"
      return 0
    fi
    print "STASH_RESTORED=yes"
    print "WARN: work restored but git stash drop failed for ${ref}"
    return 0
  fi

  print "STASH_RESTORED=no"
  print "STASH_KEPT=yes"
  print "STASH_TOKEN=${STASH_TOKEN}"
  print "STASH_REF=${ref}"
  print "WARN: stash apply --index failed; stash was not dropped"
  print "Run: git stash list"
  return 1
}

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || die "not a git repository"

repo_root="$(git rev-parse --show-toplevel)" || die "cannot resolve repository root"
cd "$repo_root" || die "cannot cd to ${repo_root}"

git_dir="$(git rev-parse --git-dir)" || die "cannot resolve git dir"

if [[ -d "${git_dir}/rebase-merge" || -d "${git_dir}/rebase-apply" ]]; then
  die "a rebase is already in progress; resolve or abort it first"
fi
if [[ -f "${git_dir}/MERGE_HEAD" ]]; then
  die "a merge is already in progress; resolve or abort it first"
fi
if [[ -f "${git_dir}/CHERRY_PICK_HEAD" ]]; then
  die "a cherry-pick is already in progress; resolve or abort it first"
fi
if [[ -f "${git_dir}/REVERT_HEAD" ]]; then
  die "a revert is already in progress; resolve or abort it first"
fi

branch="$(git branch --show-current)"
[[ -n "$branch" ]] || die "detached HEAD; check out a branch first"

print "REPO=${repo_root}"
print "BRANCH=${branch}"

status="$(git status --porcelain=v1)"
STASHED="no"
STASH_TOKEN="git-rebase-skill-${branch}-$$"

if [[ -n "$status" ]]; then
  print "WIP=yes"
  print "$status"
  if ! git stash push --include-untracked --message "$STASH_TOKEN"; then
    die "failed to stash staged, unstaged, and untracked work"
  fi
  STASHED="yes"
  print "STASHED=yes"
  print "STASH_TOKEN=${STASH_TOKEN}"
else
  print "WIP=no"
  print "STASHED=no"
fi

if ! git fetch origin; then
  print "ERROR: git fetch origin failed"
  restore_stash || true
  exit 1
fi

trunk=""
if git rev-parse --verify -q refs/remotes/origin/HEAD >/dev/null; then
  trunk="$(git rev-parse --abbrev-ref origin/HEAD)"
elif git rev-parse --verify -q refs/remotes/origin/main >/dev/null; then
  trunk="origin/main"
elif git rev-parse --verify -q refs/remotes/origin/master >/dev/null; then
  trunk="origin/master"
else
  print "ERROR: cannot determine trunk (tried origin/HEAD, origin/main, origin/master)"
  restore_stash || true
  exit 1
fi

print "TRUNK=${trunk}"

behind="$(git rev-list --count HEAD.."${trunk}")" || behind="?"
ahead="$(git rev-list --count "${trunk}"..HEAD)" || ahead="?"
print "BEHIND_TRUNK=${behind}"
print "AHEAD_OF_TRUNK=${ahead}"

if git rebase "$trunk"; then
  print "REBASE=success"
  print "HEAD=$(git rev-parse --short HEAD)"
  if restore_stash; then
    :
  else
    print "ERROR: rebase succeeded but stash restore failed; work is still in the stash"
    exit 1
  fi
else
  print "REBASE=conflicts"
  print "HEAD=$(git rev-parse --short HEAD)"
  print "STASH_KEPT=${STASHED}"
  if [[ "$STASHED" == "yes" ]]; then
    print "STASH_TOKEN=${STASH_TOKEN}"
    print "After git rebase --continue, run: git stash pop --index"
    print "After git rebase --abort, run: git stash pop --index"
  fi
  exit 1
fi

upstream="$(git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null || true)"
if [[ -n "$upstream" ]]; then
  print "UPSTREAM=${upstream}"
  local_only="$(git rev-list --count "${upstream}"..HEAD)"
  remote_only="$(git rev-list --count HEAD.."${upstream}")"
  print "DIVERGED_LOCAL=${local_only}"
  print "DIVERGED_REMOTE=${remote_only}"
  if [[ "$local_only" != "0" && "$remote_only" != "0" ]]; then
    print "FORCE_WITH_LEASE_NEEDED=yes"
  else
    print "FORCE_WITH_LEASE_NEEDED=no"
  fi
else
  print "UPSTREAM="
  print "FORCE_WITH_LEASE_NEEDED=no"
fi

print "DONE=yes"
exit 0
