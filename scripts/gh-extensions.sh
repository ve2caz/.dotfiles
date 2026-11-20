#!/usr/bin/env bash
# Installs the gh extensions listed below at their pinned tags. Skips what is already at its pin,
# so it is safe to rerun. --check only reports what differs from the list, for the doctor.
# Needs no gh login: the installed tag comes from the manifest gh writes for a binary extension,
# and installing uses GitHub's anonymous API.
set -euo pipefail

# One line per extension: owner/repo, then the pinned release tag. To move a pin, edit the tag and
# rerun this script. `gh extension upgrade` skips pinned extensions.
GH_EXTENSIONS=(
    "dlvhdr/gh-dash v4.26.3"
)

check=no
case "${1-}" in
    --check) check=yes ;;
    "") ;;
    *) echo "Usage: gh-extensions.sh [--check]" >&2; exit 2 ;;
esac

command -v gh >/dev/null || { echo "❌ gh is not installed" >&2; exit 1; }

extensions_dir="${XDG_DATA_HOME:-$HOME/.local/share}/gh/extensions"

problems=0
for line in "${GH_EXTENSIONS[@]}"; do
    read -r repo pin <<< "$line"
    manifest="$extensions_dir/${repo#*/}/manifest.yml"
    have=""
    if [ -f "$manifest" ] && grep -qx "owner: ${repo%%/*}" "$manifest"; then
        have="$(sed -n 's/^tag: //p' "$manifest")"
    fi
    if [ "$have" = "$pin" ]; then
        continue
    fi
    if [ "$check" = yes ]; then
        echo "❌ $repo is ${have:-not installed}, the list pins $pin"
        problems=$((problems + 1))
        continue
    fi
    gh extension install "$repo" --pin "$pin" --force
done

[ "$problems" -eq 0 ]
