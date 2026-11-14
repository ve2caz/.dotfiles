# .dotfiles skills

Personal skills from this repo, linked into every agent by `scripts/link-skills.sh`. Create or convert one with `new-skill`.

## User-invoked

Reachable only when you type them (Claude Code, Cursor and pi: `disable-model-invocation: true`; Codex: `policy.allow_implicit_invocation: false` in `agents/openai.yaml`).

- **[git-rebase](./git-rebase/SKILL.md)**: Rebase the current branch onto the remote trunk, keeping staged, unstaged and untracked work.
- **[git-clean-local-branches](./git-clean-local-branches/SKILL.md)**: Propose which local git branches are safe to delete, then delete only the ones you approve.
- **[git-branch](./git-branch/SKILL.md)**: Create a ticket branch from the head of main and push it empty to the remote as a baseline.
- **[git-clone-pr](./git-clone-pr/SKILL.md)**: Create a git worktree from a GitHub pull request for local code review.

## Model-invoked

Model- or user-reachable.

- **[new-skill](./new-skill/SKILL.md)**: Create or convert an agent skill in the .dotfiles repo, with front matter that Claude Code, Cursor, Codex and pi all read.
