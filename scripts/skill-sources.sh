# shellcheck shell=bash disable=SC2034
# Sourced by the skill scripts, after they set REPO. Lists where skills come from and the folders
# they go into.

# This repo's skills, linked with Stow so an edit reaches every agent at once (ADR 0003).
SKILL_BUCKETS=("$REPO/skills/dotfiles")
SKILL_TARGETS=("$HOME/.claude/skills" "$HOME/.agents/skills")

# Everyone else's skills, installed with the skills CLI from mise.toml at a pinned version (ADR 0008).
# One line per GitHub repo: owner/repo, the pinned tag or full commit, then what to take from it.
# A folder ending in /* takes every skill in that folder; a skill's folder path, or its name when
# only one folder in the repo has it, takes that one skill.
# scripts/update-skills.sh moves a pin forward after showing what changed.
THIRD_PARTY_SKILLS=(
    "herdrdev/herdr v0.9.5 herdr"
    "modem-dev/hunk v0.25.0 packages/hunk/skills/hunk-review"
    "mattpocock/skills 5863806dd4e15c63174bee4e7515a4256792ecfa skills/engineering/* skills/productivity/*"
)
