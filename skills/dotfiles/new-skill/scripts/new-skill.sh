#!/usr/bin/env bash
# Creates or converts a skill in the .dotfiles repo's skills/dotfiles bucket, then links it into every agent.
set -euo pipefail

die() { echo "❌ $*" >&2; exit 1; }

usage() {
    echo "Usage: new-skill.sh --name <name> --invocation <user|model> --description <text>" >&2
    echo "       --display-name <text> --short-description <text> [--from <folder>] [--no-link]" >&2
    exit 2
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
REPO="$(cd "$script_dir/../../../.." && pwd -P)"
bucket="$REPO/skills/dotfiles"
if [ ! -f "$REPO/AGENTS.md" ] || [ ! -f "$REPO/scripts/skill-sources.sh" ] || [ ! -d "$bucket" ]; then
    die "cannot find the .dotfiles repo from $script_dir"
fi
. "$REPO/scripts/skill-sources.sh"

name="" invocation="" description="" display_name="" short_description="" from="" link=yes
while [ $# -gt 0 ]; do
    case "$1" in
        --name|--invocation|--description|--display-name|--short-description|--from)
            [ $# -ge 2 ] || die "$1 needs a value" ;;
        --no-link) link=no; shift; continue ;;
        -h|--help) usage ;;
        *) die "unknown option: $1" ;;
    esac
    case "$1" in
        --name) name="$2" ;;
        --invocation) invocation="$2" ;;
        --description) description="$2" ;;
        --display-name) display_name="$2" ;;
        --short-description) short_description="$2" ;;
        --from) from="$2" ;;
    esac
    shift 2
done

if [ -z "$name" ] || [ -z "$invocation" ] || [ -z "$description" ] || [ -z "$display_name" ] || [ -z "$short_description" ]; then
    usage
fi
printf '%s' "$name" | grep -Eq '^[a-z0-9]+(-[a-z0-9]+)*$' \
    || die "name must be lowercase letters and digits, joined by single hyphens: $name"
[ "${#name}" -le 64 ] || die "name is longer than 64 characters"
[ "${#description}" -le 1024 ] || die "description is longer than 1024 characters"
case "$invocation" in user|model) ;; *) die "--invocation must be user or model" ;; esac

emdash=$'\xe2\x80\x94'
for text in "$description" "$display_name" "$short_description"; do
    case "$text" in *$'\n'*) die "text must be one line: $text" ;; esac
    case "$text" in *"$emdash"*) die "text must not contain an em dash: $text" ;; esac
done

target="$bucket/$name"
[ ! -e "$target" ] || die "skills/dotfiles/$name already exists"

from_real=""
if [ -n "$from" ]; then
    [ -f "$from/SKILL.md" ] || die "no SKILL.md in --from folder: $from"
    from_real="$(cd "$from" && pwd -P)"
fi
for dir in "${SKILL_BUCKETS[@]}" "${SKILL_TARGETS[@]}" "$HOME/.cursor/skills"; do
    other="$dir/$name"
    if [ ! -e "$other" ]; then continue; fi
    if [ -n "$from_real" ] && [ "$(cd "$other" && pwd -P)" = "$from_real" ]; then continue; fi
    die "a skill named $name already exists: $other"
done

yaml_quote() { local s="${1//\\/\\\\}"; printf '"%s"' "${s//\"/\\\"}"; }

mkdir -p "$target/agents"
{
    echo "---"
    echo "name: $name"
    echo "description: $(yaml_quote "$description")"
    if [ "$invocation" = user ]; then echo "disable-model-invocation: true"; fi
    echo "metadata:"
    echo "  source: dotfiles"
    echo "---"
    echo ""
    if [ -n "$from" ]; then
        awk 'NR == 1 && $0 == "---" { fm = 1; next } fm && $0 == "---" { fm = 0; next } !fm' "$from/SKILL.md" | sed '/./,$!d'
    else
        echo "# $display_name"
    fi
} > "$target/SKILL.md"

{
    echo "interface:"
    echo "  display_name: $(yaml_quote "$display_name")"
    echo "  short_description: $(yaml_quote "$short_description")"
    if [ "$invocation" = user ]; then
        echo "policy:"
        echo "  allow_implicit_invocation: false"
    fi
} > "$target/agents/openai.yaml"

if [ -n "$from" ]; then
    for sub in scripts references assets; do
        if [ -d "$from/$sub" ]; then cp -R "$from/$sub" "$target/"; fi
    done
fi

summary="$description"
section="## User-invoked"
if [ "$invocation" = model ]; then
    section="## Model-invoked"
    summary="${description%%. *}"
    case "$summary" in *.) ;; *) summary="$summary." ;; esac
fi
readme="$bucket/README.md"
grep -qxF "$section" "$readme" || printf '\n%s\n' "$section" >> "$readme"
awk -v sec="$section" -v entry="- **[$name](./$name/SKILL.md)**: $summary" '
    function add() { if (insec && !done) { if (last !~ /^- /) print ""; print entry; done = 1 } }
    $0 == sec { for (; blanks > 0; blanks--) print ""; insec = 1; last = $0; print; next }
    insec && /^## / { add(); insec = 0 }
    /^$/ { blanks++; next }
    { for (; blanks > 0; blanks--) print ""; print; last = $0 }
    END { add() }
' "$readme" > "$readme.tmp" && mv "$readme.tmp" "$readme"

abs='(\$HOME|~|/Users/[^/]+)/\.(cursor|claude|agents)/skills/[a-z0-9-]+/'
if grep -nE "$abs" "$target/SKILL.md"; then
    echo "⚠️  Replace the absolute paths above with paths relative to the skill folder, such as scripts/<file>."
fi

echo "✅ Created skills/dotfiles/$name"
if [ "$link" = yes ]; then
    if [ -x "$REPO/scripts/link-skills.sh" ]; then
        "$REPO/scripts/link-skills.sh"
    else
        echo "ℹ️  scripts/link-skills.sh does not exist yet, so the skill is not linked."
    fi
fi
echo "Next: write the body of $target/SKILL.md, then run $script_dir/check-skills.sh"
