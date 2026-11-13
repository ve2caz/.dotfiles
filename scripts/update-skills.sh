#!/usr/bin/env bash
# Moves the pins in scripts/skill-sources.sh forward. For each source with a newer release (or commit,
# when the pin is a commit), shows the commits that touched the listed skills and asks before
# moving the pin; then installs and runs the doctor. Commit skill-sources.sh to pin every machine.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
SOURCES="$REPO/scripts/skill-sources.sh"
. "$REPO/scripts/skill-sources.sh"
. "$REPO/scripts/third-party-skills.sh"

moved=no
for line in "${THIRD_PARTY_SKILLS[@]}"; do
    read -r -a parts <<< "$line"
    repo="${parts[0]}" pin="${parts[1]}"
    copy="$(skill_repo "$repo")"
    if [[ $pin =~ ^[0-9a-f]{40}$ ]]; then
        latest="$(git -C "$copy" rev-parse HEAD)"
    else
        # The newest release, leaving out pre-releases such as v1.2.0-beta.1.
        latest="$(git -C "$copy" tag --sort=-v:refname | grep -v -- - | head -n 1 || true)"
    fi
    if [ -z "$latest" ] || [ "$latest" = "$pin" ]; then
        echo "✅ $repo is at its newest version, $pin"
        continue
    fi

    folders=()
    for item in "${parts[@]:2}"; do
        for ref in "$pin" "$latest"; do
            while IFS=$'\t' read -r _ folder; do folders+=("$folder"); done < <(skill_paths "$copy" "$ref" "$item" || true)
        done
    done
    log="$(git -C "$copy" log --oneline "$pin..$latest" -- ${folders[@]+"${folders[@]}"})"
    if [ -z "$log" ]; then
        echo "✅ $repo: $latest changes none of the listed skills; staying on $pin"
        continue
    fi

    echo ""
    echo "$repo: $pin -> $latest. Commits that touch the listed skills:"
    printf '%s\n' "$log" | sed 's/^/   /'
    echo "   https://github.com/$repo/compare/$pin...$latest"
    printf 'Move the pin? [y/N] '
    read -r answer || answer=""
    case "$answer" in
        y|Y)
            tmp="$(mktemp)"
            sed "s|\"$repo $pin |\"$repo $latest |" "$SOURCES" > "$tmp" && cat "$tmp" > "$SOURCES" && rm -f "$tmp"
            moved=yes
            ;;
        *) echo "Skipped." ;;
    esac
done

"$REPO/scripts/install-skills.sh"
"$REPO/scripts/doctor.sh"
if [ "$moved" = yes ]; then
    echo ""
    echo "Commit scripts/skill-sources.sh, so the other machines install the same versions."
fi
