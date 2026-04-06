# Verification and tests

Run these from the **repository root** (`~/.dotfiles`) unless noted.

## Primary: zsh PATH and mise shims

```bash
zsh ./scripts/test/test-mise-shims-path.zsh
```

This script exercises four zsh session combinations (interactive/login variants) with a clean temporary XDG/mise environment and asserts that **mise shims** appear in `PATH` within the first few entries (`MAX_MISE_INDEX`, default 5). Use it after edits to:

- `.zshenv`, `.zprofile`, `.zshrc`, or files under `.zsh/`
- Anything that changes **PATH** order or mise activation

Optional environment overrides (see script): `TEST_HOME`, `TEST_ZDOTDIR`, `MAX_MISE_INDEX`.

## Installation smoke check

```bash
./scripts/check-installation.sh
```

Lists whether expected CLI tools are on `PATH` (bash; safe before zsh is fully configured).

## Session-type probes (manual / debugging)

Small scripts that print `PATH` one entry per line for a given session type. They are **not** a single combined automated suite; use them to inspect PATH when debugging startup.

| Script | Session |
|--------|---------|
| `scripts/test/interactive-login.sh` | interactive login |
| `scripts/test/interactive-non-login.sh` | interactive non-login |
| `scripts/test/non-interactive-login.sh` | non-interactive login |
| `scripts/test/non-interactive-non-login.sh` | non-interactive non-login |

Example:

```bash
bash ./scripts/test/non-interactive-non-login.sh
```

## Shell harness scripts (broader checks)

Under `scripts/test/` there are additional drivers for interactive vs non-interactive shells (see file names). Prefer **`test-mise-shims-path.zsh`** for routine validation of PATH/mise behavior after dotfile changes.

## When to run what

| Change | Suggested check |
|--------|-----------------|
| zsh init / PATH / mise | `zsh ./scripts/test/test-mise-shims-path.zsh` |
| New CLI expected from install script | `./scripts/check-installation.sh` |
| Only theme assets | No strict automated test in-repo; follow [`doc/tokyo-night-theme.md`](../doc/tokyo-night-theme.md) if touching theme scripts |
