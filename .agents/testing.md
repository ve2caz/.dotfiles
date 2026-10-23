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

The script also prints `PATH` one entry per line for each session type, which is the quickest way to inspect startup order when debugging.

## Key bindings

```bash
zsh ./scripts/test/test-keybindings.zsh
```

Drives a real interactive zsh through a pseudo terminal and proves every key in the cheat sheets: the zle widgets, the fzf-driven keys (with a stub `fzf`), the binds inside fzf, and the keys WezTerm or the herdr prefix take first. It fails if a cheat sheet lists a key the test does not cover. Known-broken keys are expected failures with a reason; one that starts working fails the run until its marker is removed. Run it after changes to key bindings, zsh plugins, `FZF_DEFAULT_OPTS`, `wezterm.lua` or `herdr/config.toml`. It needs a real pseudo terminal, so it cannot run inside the Cursor agent sandbox. `KB_LOG=<file>` saves the session output and `KB_KEEP=1` keeps the temporary folder.

One check stays manual: that WezTerm sends `ESC` plus the key for left Option on this keyboard. In WezTerm, run `cat -v`, press Option-C, and expect `^[c`.

## Packages

`brew bundle check --verbose` lists what the `Brewfile` asks for and is missing.

## When to run what

| Change | Suggested check |
|--------|-----------------|
| zsh init / PATH / mise | `zsh ./scripts/test/test-mise-shims-path.zsh` |
| Key bindings, zsh plugins, fzf options, WezTerm or herdr keys | `zsh ./scripts/test/test-keybindings.zsh` |
| `Brewfile` | `brew bundle check --verbose` |
