#!/usr/bin/env bash
# Installs the third-party skills listed in scripts/skill-sources.sh at their pinned versions, for
# Claude Code (~/.claude/skills) and the agents that read ~/.agents/skills, and removes the ones no
# longer listed. Skips what is already at its pin, so it is safe to rerun.
# --check only reports what differs from the list, for the doctor.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
. "$REPO/scripts/skill-sources.sh"
. "$REPO/scripts/third-party-skills.sh"

check=no
case "${1-}" in
    --check) check=yes ;;
    "") ;;
    *) echo "Usage: install-skills.sh [--check]" >&2; exit 2 ;;
esac

# This repo's skill names: a third-party skill with one of them would replace its link silently.
ours=" "
for dir in "$REPO/skills/dotfiles"/*/; do
    [ -f "$dir/SKILL.md" ] && ours="$ours$(basename "$dir") "
done

# Resolve every listed skill first, so a clash or a bad pin stops the run before anything changes.
problems=0
wanted=" "
todo=()
problem() { echo "❌ $1"; problems=$((problems + 1)); }
for line in "${THIRD_PARTY_SKILLS[@]}"; do
    read -r -a parts <<< "$line"
    repo="${parts[0]}" pin="${parts[1]}"
    copy="$(skill_repo "$repo")"
    if ! git -C "$copy" rev-parse -q --verify "$pin^{commit}" >/dev/null; then
        problem "$repo: the pin $pin is not a tag or commit there"
        continue
    fi
    for item in "${parts[@]:2}"; do
        names="$(skill_paths "$copy" "$pin" "$item" | cut -f1 || true)"
        if [ -z "$names" ]; then
            problem "$repo: $item matches no skill at $pin"
            continue
        fi
        if [ "${item%/\*}" = "$item" ] && [ "$(printf '%s\n' "$names" | grep -c .)" -gt 1 ]; then
            problem "$repo: $item matches more than one skill at $pin; give the path of its folder"
            continue
        fi
        current=yes
        for name in $names; do
            case "$ours" in *" $name "*) problem "$name from $repo has the name of this repo's skill" ;; esac
            case "$wanted" in *" $name "*) problem "$name is listed twice" ;; esac
            wanted="$wanted$name "
            if [ "$(skill_ref "$name")" != "$pin" ] || [ ! -e "$HOME/.claude/skills/$name" ]; then
                current=no
            fi
        done
        [ "$current" = yes ] || todo+=("$repo $pin $item")
    done
done

unlisted=""
if [ -f "$SKILL_LOCK" ]; then
    for name in $(jq -r '.skills | keys[]' "$SKILL_LOCK"); do
        case "$wanted" in *" $name "*) ;; *) unlisted="$unlisted $name" ;; esac
    done
fi

if [ "$check" = yes ]; then
    for t in ${todo[@]+"${todo[@]}"}; do problem "not installed at its pin: $t"; done
    for name in $unlisted; do problem "installed but not listed in scripts/skill-sources.sh: $name"; done
    [ "$problems" -eq 0 ] && echo "✅ Third-party skills match scripts/skill-sources.sh"
    [ "$problems" -eq 0 ]
    exit
fi
[ "$problems" -eq 0 ] || { echo "Nothing installed."; exit 1; }

for t in ${todo[@]+"${todo[@]}"}; do
    read -r repo pin item <<< "$t"
    if [ "${item%/\*}" != "$item" ]; then
        set -- "https://github.com/$repo/tree/$pin/${item%/\*}" --skill '*'
    elif [ "${item#*/}" != "$item" ]; then
        set -- "https://github.com/$repo/tree/$pin/$item" --skill "${item##*/}"
    else
        set -- "$repo@$pin" --skill "$item"
    fi
    if ! out="$(skills_cli add "$@" -g -a claude-code -a codex -y 2>&1)"; then
        printf '%s\n' "$out"
        echo "❌ Could not install $item from $repo at $pin"
        exit 1
    fi
    echo "✅ Installed $item from $repo at $pin"
done

for name in $unlisted; do
    skills_cli remove -g --skill "$name" -y >/dev/null
    echo "🗑️  Removed $name, which scripts/skill-sources.sh no longer lists"
done

[ ${#todo[@]} -gt 0 ] || [ -n "$unlisted" ] || echo "✅ Third-party skills already match scripts/skill-sources.sh"
