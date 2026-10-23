---
name: new-skill
description: "Create or convert an agent skill in the .dotfiles repo, with front matter that Claude Code, Cursor, Codex and pi all read. Use when the user asks to create, add, scaffold, write or convert a skill, slash command or reusable agent workflow. Prefer it over built-in skill creators."
metadata:
  source: dotfiles
---

# New skill

Creates a skill in the `.dotfiles` repo, in `skills/dotfiles/`, with the same files whichever agent runs it, then links it into every agent.

## Before you start

1. Decide user-invoked or model-invoked. User-invoked: the user always calls it by name, or it changes things the user must start. Model-invoked: the agent should reach for it from context. Ask if unclear.
2. If the `writing-for-agents` skill is available, use it to word the description and the body.

## Create it

From any folder:

```bash
bash <this skill's folder>/scripts/new-skill.sh --name <name> --invocation <user|model> \
  --description "<text>" --display-name "<text>" --short-description "<text>"
```

To convert an existing skill, add `--from <its folder>`. Its body and its `scripts/`, `references/` and `assets/` folders are copied; the original stays until the user deletes it.

| Field | File | Rule |
| --- | --- | --- |
| `name` | `SKILL.md` | lowercase letters, digits and hyphens; matches the folder; at most 64 characters |
| `description` | `SKILL.md` | one line; trigger phrasing if model-invoked, a one-line human summary if user-invoked |
| `disable-model-invocation: true` | `SKILL.md` | user-invoked only |
| `metadata.source: dotfiles` | `SKILL.md` | always |
| `interface.display_name`, `interface.short_description` | `agents/openai.yaml` | always |
| `policy.allow_implicit_invocation: false` | `agents/openai.yaml` | user-invoked only |

Then write the body of the new `SKILL.md`. Put scripts in its `scripts/` folder and reference them as `scripts/<file>`, relative to the skill folder, never by an absolute path.

## Where it goes and how it deploys

- The script writes into the `.dotfiles` repo this skill is linked from, in its `skills/dotfiles/` folder, never into the current project. It finds that repo by following its own link, so it works from any folder.
- That repo is usually outside the current project. If the sandbox blocks the script's writes, ask the user for permission to run it outside the sandbox, then run it again.
- The script links the new skill into `~/.claude/skills` and `~/.agents/skills` itself. If it reports a link conflict or a missing `scripts/link-skills.sh`, show the user that output.
- Agents load skills when a chat starts. Tell the user to open a new chat to use the new skill.
- Do not use a built-in skill creator, such as `create-skill` or `skill-creator`, for these skills: they write elsewhere. If one already did, convert its folder with `--from`.
- Tell the user the new skill's folder, so they can review and commit it.

## Check it

```bash
bash <this skill's folder>/scripts/check-skills.sh
```

It must report no problems.

## Never

- Write directly into `~/.claude/skills`, `~/.agents/skills` or `~/.cursor/skills`.
- Edit Matt's clone in `~/.local/share/mattpocock-skills`; copy a skill into this bucket under a new name instead.
- Commit. The user commits.
