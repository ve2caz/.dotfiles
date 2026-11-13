# 0003: Deploy skills with Stow, one package per bucket

Status: accepted, 2026-10-22.

**Context.** Skills lived untracked in `~/.cursor/skills`, visible only to Cursor. Harnesses read different folders. The Agent Skills client guide names `~/.agents/skills` as the cross-client location, and pi, Codex and Cursor read it. Claude Code reads only `~/.claude/skills`; Cursor reads that too, plus its own `~/.cursor/skills`. Matt Pocock's skills repo links each skill, flattened, into the first two with a script.

**Decision.** This repo's `skills/dotfiles/` is a Stow package; other people's skills come from the skills CLI (ADR 0008). `scripts/link-skills.sh` stows every bucket listed in `scripts/skill-sources.sh` into `~/.claude/skills` and `~/.agents/skills`. `~/.cursor/skills` is not a target.

**Alternatives rejected.** A plain `ln -s` loop, as Matt uses: Stow is already a dependency and adds dry runs, clean unlinking and conflict checks. One package holding all buckets: the bucket level would appear in the targets, and harnesses expect skills one level deep. Copying: copies drift from the repo. Linking into `~/.claude/skills` only: no duplicates, but every harness other than Claude Code and Cursor would need its own setting.

**Consequences.** Skill folder names must be unique across this repo's skills and the third-party ones. Each target must be a real directory before stowing, or Stow folds it into the repo. The Cursor CLI lists each skill twice because it reads both targets; the Cursor IDE lists it once. Accepted: the copies are identical, and the client guide asks harnesses to resolve name collisions.
