#!/usr/bin/env bash
# Links every skill bucket listed in scripts/skill-sources.sh into each agent skill folder with GNU Stow.
# Pass -n for a dry run, -D to unlink.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
. "$REPO/scripts/skill-sources.sh"

flags=()
dry_run=no
for arg in "$@"; do
    case "$arg" in
        -n) flags+=("-n"); dry_run=yes ;;
        -D) flags+=("-D") ;;
        *) echo "Usage: link-skills.sh [-n] [-D]" >&2; exit 2 ;;
    esac
done

for dest in "${SKILL_TARGETS[@]}"; do
    if [ -L "$dest" ]; then
        echo "❌ $dest is a link; it must be a real folder, or Stow writes skill links into the repo." >&2
        exit 1
    fi
    if [ ! -d "$dest" ]; then
        if [ "$dry_run" = yes ]; then
            echo "ℹ️  would create $dest"
            continue
        fi
        mkdir -p "$dest"
    fi
    for bucket in "${SKILL_BUCKETS[@]}"; do
        if [ ! -d "$bucket" ]; then
            echo "ℹ️  skipping missing bucket: $bucket"
            continue
        fi
        echo "🔗 $bucket -> $dest"
        stow -v ${flags[@]+"${flags[@]}"} -d "$(dirname "$bucket")" -t "$dest" "$(basename "$bucket")"
    done
done
