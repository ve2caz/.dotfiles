# Verification and tests

Run these from the **repository root** (`~/.dotfiles`) unless noted.

## Primary: zsh PATH and mise shims

```bash
zsh ./scripts/test/test-mise-shims-path.zsh
```

This script exercises four zsh session combinations (interactive/login variants) with a clean temporary XDG/mise environment and asserts that **mise shims** appear in `PATH` within the first few entries (`MAX_MISE_INDEX`, default 5). Use it after edits to:

- `home/.zshenv`, `home/.zprofile`, `home/.zshrc`, or files under `home/.zsh/`
- Anything that changes **PATH** order or mise activation

Optional environment overrides (see script): `TEST_HOME`, `TEST_ZDOTDIR`, `MAX_MISE_INDEX`.

The test runs without zinit and without prompt hooks, so it cannot see what `.zshrc` does to `PATH`. After changing `.zshrc`, `zsh -i -c 'print -l $path'` and `zsh -c 'print -l $path'` must print the same list.

The shims matter most to processes that never see a prompt, such as Tilt and its extensions ([ADR 0005](adr/0005-mise-shims-in-every-zsh.md)). After changes to startup files, `PATH` or mise, run this from a project folder with a `mise.toml`, replacing `<tool>` with any tool it pins: `env -i HOME="$HOME" TERM="$TERM" PATH=/usr/bin:/bin zsh -c 'sh -c "command -v <tool>; mise current <tool>"'`. It must print `~/.local/share/mise/shims/<tool>` and the version the project pins.

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
