# shellcheck shell=bash
# Sourced by install-skills.sh and update-skills.sh, after skill-sources.sh. Helpers for the
# third-party skills in THIRD_PARTY_SKILLS.

# Where the skills CLI keeps its record of global installs: under XDG_STATE_HOME when it is set.
if [ -n "${XDG_STATE_HOME-}" ]; then
    SKILL_LOCK="$XDG_STATE_HOME/skills/.skill-lock.json"
else
    SKILL_LOCK="$HOME/.agents/.skill-lock.json"
fi
SKILL_REPO_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles/skill-sources"

# The skills CLI from mise.toml, which also turns its telemetry off.
skills_cli() { (cd "$REPO" && mise exec -- skills "$@"); }

# skill_repo <owner/repo>: prints the path of a local copy of the repo with its history but no
# file contents, fetched up to date. Used to list skills and show commits, never to install.
skill_repo() {
    local dir="$SKILL_REPO_CACHE/${1//\//--}.git"
    if [ -d "$dir" ]; then
        git -C "$dir" fetch --quiet --force --tags origin '+refs/heads/*:refs/heads/*'
    else
        mkdir -p "$SKILL_REPO_CACHE"
        git clone --quiet --bare --filter=blob:none "https://github.com/$1.git" "$dir"
    fi
    printf '%s\n' "$dir"
}

# skill_paths <repo copy> <ref> <item>: prints "name<TAB>folder" for each skill the item selects:
# folder/* for every skill in a folder, a folder path for that one skill, or a skill name.
skill_paths() {
    local copy=$1 ref=$2 item=$3 file folder
    if [ "${item%/\*}" != "$item" ]; then
        git -C "$copy" ls-tree -r --name-only "$ref" -- "${item%/\*}/" | grep -E "^${item%/\*}/[^/]+/SKILL\.md$"
    elif [ "${item#*/}" != "$item" ]; then
        git -C "$copy" ls-tree -r --name-only "$ref" -- "$item/SKILL.md"
    else
        git -C "$copy" ls-tree -r --name-only "$ref" | grep -E "(^|/)$item/SKILL\.md$"
    fi | while IFS= read -r file; do
        folder="${file%/SKILL.md}"
        printf '%s\t%s\n' "${folder##*/}" "$folder"
    done
}

# skill_ref <name>: the ref the skills CLI installed a skill from, or nothing when it is not installed.
skill_ref() {
    [ -f "$SKILL_LOCK" ] || return 0
    jq -r --arg n "$1" '.skills[$n].ref // empty' "$SKILL_LOCK"
}
