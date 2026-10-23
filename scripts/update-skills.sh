#!/usr/bin/env bash
# Clones or updates Matt's skills: shows new commits, pulls them after confirmation, then relinks and runs the doctor.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
. "$REPO/scripts/skill-sources.sh"

if [ ! -d "$MATT_SKILLS_CLONE/.git" ]; then
    git clone --quiet https://github.com/mattpocock/skills.git "$MATT_SKILLS_CLONE"
    echo "✅ Cloned Matt's skills into $MATT_SKILLS_CLONE"
else
    git -C "$MATT_SKILLS_CLONE" fetch --quiet origin
    new="$(git -C "$MATT_SKILLS_CLONE" log --oneline 'HEAD..@{upstream}')"
    if [ -z "$new" ]; then
        echo "✅ Matt's skills are up to date"
    else
        echo "New commits in Matt's skills:"
        echo "$new"
        printf 'Apply these updates? [y/N] '
        read -r answer
        case "$answer" in
            y|Y) git -C "$MATT_SKILLS_CLONE" pull --ff-only --quiet ;;
            *) echo "Skipped."; exit 0 ;;
        esac
    fi
fi

"$REPO/scripts/link-skills.sh"
"$REPO/scripts/doctor.sh"
