#!/usr/bin/env bash
# Read-only inventory of local git branches.
# Does not fetch, prune, checkout, or delete.
set -u

print() { printf '%s\n' "$*"; }

die() {
  print "ERROR: $*"
  exit 1
}

git rev-parse --git-dir >/dev/null 2>&1 || die "not a git repository"

root=$(git rev-parse --show-toplevel)
print "REPO=${root}"

current=$(git branch --show-current || true)
if [[ -z "$current" ]]; then
  current="(detached)"
fi
print "CURRENT=${current}"

default_remote=""
if git show-ref --verify --quiet refs/remotes/origin/HEAD; then
  default_remote=$(git symbolic-ref --short refs/remotes/origin/HEAD)
fi
default_local="${default_remote#origin/}"
if [[ -z "$default_local" || "$default_local" == "$default_remote" ]]; then
  if git show-ref --verify --quiet refs/heads/main; then
    default_local="main"
  elif git show-ref --verify --quiet refs/heads/master; then
    default_local="master"
  else
    default_local=""
  fi
fi
print "DEFAULT=${default_local:-unknown}"

# path, branch, role (primary|linked), locked (yes|no)
# A branch checked out here must not be deleted: that worktree would break.
worktree_map=$(git worktree list --porcelain | awk '
  BEGIN { kind = "linked"; locked = "no" }
  function emit() {
    if (path == "") return
    if (branch == "") branch = "(none)"
    role = (n == 0 ? "primary" : kind)
    printf "%s\t%s\t%s\t%s\n", path, branch, role, locked
    n++
    path = ""
    branch = ""
    kind = "linked"
    locked = "no"
  }
  /^worktree / { emit(); path = substr($0, 10); next }
  /^branch / { sub(/^branch refs\/heads\//, ""); branch = $0; next }
  /^detached$/ { branch = "(detached)"; next }
  /^bare$/ { kind = "bare"; next }
  /^locked/ { locked = "yes"; next }
  END { emit() }
')

print "WORKTREES"
print "path	branch	role	locked"
if [[ -n "$worktree_map" ]]; then
  printf '%s\n' "$worktree_map"
else
  print "-"
fi

worktree_path_for() {
  local name="$1"
  [[ -n "$worktree_map" ]] || return 0
  printf '%s\n' "$worktree_map" | awk -F '\t' -v n="$name" '$2 == n { print $1; exit }'
}

ever_pushed() {
  local name="$1"
  local upstream="$2"
  local remote logpath

  if [[ -n "$upstream" ]]; then
    printf 'yes\tupstream:%s\n' "$upstream"
    return 0
  fi

  while IFS= read -r remote; do
    [[ -z "$remote" ]] && continue
    if git show-ref --verify --quiet "refs/remotes/${remote}/${name}"; then
      printf 'yes\tremote-ref:%s/%s\n' "$remote" "$name"
      return 0
    fi
    logpath=$(git rev-parse --git-path "logs/refs/remotes/${remote}/${name}")
    if [[ -f "$logpath" ]]; then
      printf 'yes\tremote-reflog:%s/%s\n' "$remote" "$name"
      return 0
    fi
  done < <(git remote)

  printf 'no\tnone\n'
}

count_not_in() {
  local branch="$1"
  shift
  if [[ "$#" -eq 0 ]]; then
    printf 'unknown'
    return 0
  fi
  git rev-list --count "${branch}" --not "$@" 2>/dev/null || printf 'unknown'
}

print "COLUMNS=name	current	worktree_path	has_upstream	upstream	upstream_track	ever_pushed	pushed_evidence	unique_vs_remotes	unique_vs_default	proposal	reason"
print "ROWS"

while IFS='|' read -r name upstream track; do
  [[ -z "$name" ]] && continue

  is_current=no
  [[ "$name" == "$current" ]] && is_current=yes

  worktree_path=$(worktree_path_for "$name")
  [[ -z "$worktree_path" ]] && worktree_path="-"

  if [[ -n "$upstream" ]]; then
    has_upstream=yes
  else
    has_upstream=no
  fi

  track=$(printf '%s' "$track" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  [[ -z "$track" ]] && track="-"

  pushed_line=$(ever_pushed "$name" "$upstream")
  ever=${pushed_line%%$'\t'*}
  evidence=${pushed_line#*$'\t'}

  if git for-each-ref --format='%(refname)' refs/remotes | grep -q .; then
    unique_remotes=$(count_not_in "$name" --remotes)
  else
    unique_remotes=$(git rev-list --count "$name" 2>/dev/null || printf 'unknown')
  fi

  if [[ -n "$default_local" ]]; then
    unique_default=$(count_not_in "$name" "$default_local")
  else
    unique_default=unknown
  fi

  proposal=keep
  reason=unique-commits
  if [[ "$is_current" == yes ]]; then
    reason=current-branch
  elif [[ -n "$default_local" && "$name" == "$default_local" ]]; then
    reason=default-branch
  elif [[ "$worktree_path" != "-" ]]; then
    reason=checked-out-in-worktree
  elif [[ "$unique_remotes" == "0" ]]; then
    proposal=remove
    reason=commits-on-a-remote
  elif [[ "$unique_default" == "0" ]]; then
    proposal=remove
    reason=merged-into-${default_local}
  fi

  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$name" "$is_current" "$worktree_path" "$has_upstream" "${upstream:--}" \
    "$track" "$ever" "$evidence" "$unique_remotes" "$unique_default" \
    "$proposal" "$reason"
done < <(git for-each-ref --format='%(refname:short)|%(upstream:short)|%(upstream:track)' refs/heads)
