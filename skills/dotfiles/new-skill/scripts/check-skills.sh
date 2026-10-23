#!/usr/bin/env bash
# Checks every skill in the .dotfiles repo's skills/dotfiles bucket. Read-only: it never changes anything.
set -uo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
REPO="$(cd "$script_dir/../../../.." && pwd -P)"
bucket="$REPO/skills/dotfiles"
. "$REPO/scripts/skill-sources.sh"

emdash=$'\xe2\x80\x94'
abs='(\$HOME|~|/Users/[^/]+)/\.(cursor|claude|agents)/skills/[a-z0-9-]+/'
problems=0
checked=0
ours=""
problem() { echo "❌ $1: $2"; problems=$((problems + 1)); }

front_matter() { awk 'NR == 1 { if ($0 != "---") exit; next } $0 == "---" { exit } { print }' "$1"; }
field() { printf '%s\n' "$1" | sed -n "s/^$2: *//p" | head -n 1 | sed -E 's/^"(.*)"$/\1/'; }

for dir in "$bucket"/*/; do
    [ -d "$dir" ] || continue
    dir="${dir%/}"
    folder="${dir##*/}"
    checked=$((checked + 1))
    ours="$ours $folder"
    skill="$dir/SKILL.md"
    yaml="$dir/agents/openai.yaml"

    if [ ! -f "$skill" ]; then
        problem "$folder" "SKILL.md is missing"
        continue
    fi
    fm="$(front_matter "$skill")"
    name="$(field "$fm" name)"
    description="$(field "$fm" description)"

    [ "$name" = "$folder" ] || problem "$folder" "name '$name' does not match the folder"
    case "$description" in
        "") problem "$folder" "description is missing" ;;
        ">"*|"|"*) problem "$folder" "description must be one line" ;;
    esac
    printf '%s\n' "$fm" | grep -qE '^  source: "?dotfiles"?$' || problem "$folder" "metadata.source: dotfiles is missing"

    user_invoked=no
    [ "$(field "$fm" disable-model-invocation)" = true ] && user_invoked=yes
    if [ ! -f "$yaml" ]; then
        problem "$folder" "agents/openai.yaml is missing"
    else
        grep -qE '^  display_name: ' "$yaml" || problem "$folder" "openai.yaml has no interface.display_name"
        grep -qE '^  short_description: ' "$yaml" || problem "$folder" "openai.yaml has no interface.short_description"
        implicit=yes
        grep -qE '^  allow_implicit_invocation: false$' "$yaml" && implicit=no
        if [ "$user_invoked" = yes ] && [ "$implicit" = yes ]; then
            problem "$folder" "user-invoked, but openai.yaml lacks policy.allow_implicit_invocation: false"
        elif [ "$user_invoked" = no ] && [ "$implicit" = no ]; then
            problem "$folder" "model-invoked, but openai.yaml sets policy.allow_implicit_invocation: false"
        fi
    fi

    grep -qF "](./$folder/SKILL.md)" "$bucket/README.md" || problem "$folder" "not listed in skills/dotfiles/README.md"
    hits="$(grep -rlF "$emdash" "$dir")" && problem "$folder" "em dash in: $hits"
    hits="$(grep -rnE "$abs" "$dir")" && problem "$folder" "absolute skill path: $hits"

    for b in "${SKILL_BUCKETS[@]}"; do
        [ "$b" = "$bucket" ] && continue
        [ -e "$b/$folder" ] && problem "$folder" "Matt's clone has a skill with the same name: $b/$folder"
    done
done

find "${SKILL_TARGETS[@]}" "$HOME/.cursor/skills" "$HOME/.cursor/plugins" "$HOME/.claude/plugins" -name SKILL.md 2>/dev/null |
    while IFS= read -r found; do
        other="$(basename "$(dirname "$found")")"
        case " $ours " in *" $other "*) echo "⚠️  $other: another skill with this name is installed at ${found%/SKILL.md}" ;; esac
    done

echo ""
if [ "$problems" -eq 0 ]; then
    echo "✅ $checked skill(s) in skills/dotfiles: no problems"
else
    echo "⚠️  $problems problem(s) in skills/dotfiles"
    exit 1
fi
