# Editing conventions

## Scope

- Change **only what the task requires**. Avoid drive-by refactors, unrelated files, or large formatting-only diffs.
- **Do not** add unsolicited documentation files; if documentation is needed, prefer updating existing [`doc/`](../doc/) pages or `.agents/` when agent behavior is the subject.

## Style

- **Match existing style** in shell, Lua, TOML, and YAML: naming, indentation, and comment density.
- Preserve intentional comments; do not delete unrelated code or comments.
- Prefer **one clear code path** over many special cases unless the repo already uses that pattern.

## Security

- Never commit **secrets** (tokens, passwords, private URLs with credentials).
- Respect [`.gitignore`](../.gitignore): if a generated or local file appears untracked, do not force-add it unless the user explicitly wants it versioned and it is safe to share.

## Commits and PRs

- Commit messages: **clear, complete sentences**; describe what changed and why.
- Before proposing a merge: run relevant checks from [`testing.md`](testing.md) when shell or tooling behavior changed.

## Cursor-specific rules

Project rules may also live under `.cursor/rules/` (e.g. file globs, `alwaysApply`). Those complement this file; they are not a substitute for the portable [`AGENTS.md`](../AGENTS.md) + `.agents/` layout for other tools.
