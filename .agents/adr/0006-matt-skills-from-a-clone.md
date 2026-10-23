# 0006: Matt's skills come from a clone, linked like this repo's skills

Status: accepted, 2026-10-22.

**Context.** Matt Pocock ships his skills through one channel per agent: a self-updating Claude Code plugin, Codex and Copilot plugins, and `npx skills` copies for Cursor, pi and others, updated by hand. Cursor has no plugin channel for his repo, because it imports skills only through a `.cursor-plugin/marketplace.json`, which he does not ship. Only his `engineering` and `productivity` skills are wanted.

**Decision.** `scripts/update-skills.sh` keeps a clone of `github.com/mattpocock/skills` in `~/.local/share/mattpocock-skills`, outside the repo. It shows the new commits, pulls them only after confirmation, then relinks and runs the doctor. `scripts/link-skills.sh` stows his `engineering` and `productivity` folders into the same targets as this repo's skills. His plugins are not installed.

**Alternatives rejected.** His per-agent channels: three update mechanisms, the Claude plugin is invisible to Cursor, and `npx skills` adds more copies Cursor reads. A pi package: pi only. His Agent Plugins manifest, PR #807: not merged.

**Consequences.** One mechanism serves Claude Code, Cursor and pi, and each update is reviewed before agents use it. His clone must never be edited, or `git pull --ff-only` fails; copy a skill into `skills/dotfiles/` under a new name instead. If he flattens his `skills/` folder, `scripts/skill-sources.sh` must change. Installing his plugins as well would list every skill twice.
