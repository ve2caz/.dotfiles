# Glossary

**Home package**: `home/`, the only Stow package deployed to `$HOME`.
_Avoid_: root package, dotfiles folder.

**Skill package**: one bucket, stowed as its own package into each skill target.
_Avoid_: skill set.

**Bucket**: a folder that groups skills: this repo's `skills/dotfiles/`, or a folder under `skills/` in Matt's clone. Which buckets are linked is listed in `scripts/skill-sources.sh`.
_Avoid_: category, group.

**Target**: the directory Stow links a package into: `$HOME` for the home package, `~/.claude/skills` and `~/.agents/skills` for skill packages.
_Avoid_: destination, install dir.

**Deployed**: present in a target as a Stow link into the repo.
_Avoid_: installed, copied.

**Repo-only**: in the repo but never deployed: everything outside `home/` and the linked buckets.
_Avoid_: local, internal.

**Folding**: Stow linking a whole directory as one link because the target has no directory of that name yet. Wanted for `~/.config/nvim`; must never happen to `~/.config` itself.

**Configuration**: a setting the user chose or changed. Tracked under `home/`.
_Avoid_: settings, prefs, dotfiles.

**App state**: anything a tool writes on its own: generated defaults, caches, history, tokens, downloaded themes. Never tracked. A generated default becomes configuration once the user changes it.
_Avoid_: local config, machine config.

**Harness**: a program that runs an agent and loads skills: Claude Code, Cursor, Codex, Gemini CLI, Copilot CLI.
_Avoid_: client, agent.

**User-invoked skill**: a skill that runs only when the user calls it by name.
_Avoid_: command, manual skill.

**Model-invoked skill**: a skill the harness may load on its own when its description matches the task.
_Avoid_: automatic skill.

**Worktree**: a `git worktree` checkout under `~/.dotfiles-worktree/<branch-name>`. `~/.dotfiles` is the main checkout, on `main`.
_Avoid_: clone, copy.

## Flagged ambiguities

- **`.agents/`**: the repo's `.agents/` holds repo-only agent docs (`testing.md`, `adr/`). `~/.agents/` is a skill target. They are unrelated; nothing in the repo's `.agents/` deploys.
- **`.cursor/`**: the repo has no `.cursor/` folder. `~/.cursor/` is Cursor's own folder: settings, app state, and skills kept local. Never tracked.
- **"Linux support"**: Debian/Ubuntu code paths exist but are untested. Say "untested", not "supported".
