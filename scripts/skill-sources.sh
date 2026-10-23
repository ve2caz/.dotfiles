# shellcheck shell=bash disable=SC2034
# Sourced by the skill scripts, after they set REPO. Lists the linked skill buckets and the folders they link into.
MATT_SKILLS_CLONE="${MATT_SKILLS_CLONE:-$HOME/.local/share/mattpocock-skills}"
SKILL_BUCKETS=(
    "$REPO/skills/dotfiles"
    "$MATT_SKILLS_CLONE/skills/engineering"
    "$MATT_SKILLS_CLONE/skills/productivity"
)
SKILL_TARGETS=("$HOME/.claude/skills" "$HOME/.agents/skills")
