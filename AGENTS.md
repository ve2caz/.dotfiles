# .dotfiles

Personal dotfiles, deployed with GNU Stow. What the repo covers: [SCOPE.md](SCOPE.md). Terms: [GLOSSARY.md](GLOSSARY.md). Decisions and their reasons: [.agents/adr/](.agents/adr/).

## What deploys where

- `home/` is the home package, the only thing deployed to `$HOME`: `stow -d ~/.dotfiles -t ~ home`.
- This repo's skills, `skills/dotfiles/`, are a skill package: `scripts/link-skills.sh` stows them into `~/.claude/skills` and `~/.agents/skills`. Other people's skills are installed into the same folders by `scripts/install-skills.sh` with the skills CLI. `scripts/skill-sources.sh` is the one list of both. Why: [ADR 0008](.agents/adr/0008-third-party-skills-from-the-skills-cli.md).
- Everything else is repo-only.
- `~/.config`, `~/.claude/skills` and `~/.agents/skills` must be real directories before stowing. If one is missing, Stow folds it into a single link into the repo, and tools then write app state into the repo.

## ~/.config

- Track configuration, never app state.
- Track only settings that differ from the tool's defaults, unless the tool rewrites the whole file itself (btop, htop). A copy of the defaults goes stale on upgrades and hides which lines are choices. Start the file with a comment naming where to see the defaults, such as `lazydocker -c`.
- A tool whose folder holds only configuration gets one link for the whole folder, for example `~/.config/lazygit`.
- A tool whose folder mixes configuration and app state keeps a real folder in `~/.config`, and Stow links only the tracked files, for example `~/.config/git/config`. Such a folder must exist as a real folder in `~/.config` before stowing, or Stow folds it and the tool writes app state into the repo. List it in `scripts/mixed-config-dirs.txt`, which setup, the doctor and the tests read.
- An entry in `~/.config` that stays local (app state, logins) is listed in `scripts/local-config.txt`, or in `~/.config/dotfiles/local-config.txt` when its name reveals work. The doctor reports any other entry that is not a link into the repo.
- Some tools save by replacing the file, which turns a file link into a plain file. After using a file-linked tool, `ls -la` must still show a link.

## Stow

- `home/.stow-local-ignore` lists `\.DS_Store` and `\.gitkeep`. Stow's built-in list does not skip `.DS_Store`, so a Finder copy in `home/` would be linked into `$HOME` or block the run as a conflict. A local ignore file replaces the built-in list entirely.
- Ignore patterns are Perl regexes, one per line. A pattern without `/` matches a basename. Escape literal dots.
- Dry run before every real run: `stow -n -v -d "$PWD" -t "$(mktemp -d)" home`.

## Shell startup

The main job of the zsh files is one fixed `PATH` order in every zsh, despite macOS `path_helper`. Why and how: [ADR 0004](.agents/adr/0004-path-order-over-path-helper.md).

- On macOS, `.zshenv` unsets `GLOBAL_RCS`, runs `path_helper` first, then sources `/etc/zshenv` and, for login shells, `/etc/zprofile` by hand; `.zshrc` sources `/etc/zshrc`. Keep every `path_helper` call before any user entry.
- `.zshenv` and `.zprofile` both source `.zsh/env.zsh`. A guard runs it once per zsh process. Do not export the guard: every zsh must rebuild `PATH` from the baseline, and mise's functions do not inherit.
- `PATH` order is built only in `.zsh/env.zsh`. `~/.local/bin` and `~/bin` go last, so they never shadow Homebrew or system tools. `.zshrc` removes zinit's `$ZPFX/bin` right after loading zinit. Add nothing else to `PATH` anywhere else.
- `env.zsh` puts the mise shims first in every zsh, so child processes such as Tilt and its extensions resolve each project's `mise.toml` versions without shell hooks. Never limit the shims to interactive or login shells. Why: [ADR 0005](.agents/adr/0005-mise-shims-in-every-zsh.md).
- `env.zsh` runs in every new zsh, including non-interactive ones. Keep it fast.
- Aliases exist only in human shells (a terminal, a herdr pane). Agent shells (an `AI_AGENT` or vendor marker, or no terminal on stdin) create none, keeping only zsh's `run-help` and `which-command`, and get no zoxide. Define new aliases inside the agent-shell check in `.zshrc`. Why: [ADR 0007](.agents/adr/0007-agent-shells-get-plain-tools.md).
- herdr is the terminal multiplexer and must keep working after every zsh change: a herdr pane is a human shell, and herdr's keys must still reach herdr. `scripts/test/test-keybindings.zsh` checks both.

## Scripts

Scripts in `scripts/` are bash, not zsh: they run on a fresh machine before the zsh config exists.

## Homebrew

Never run `brew install`, `brew upgrade` or `brew bundle install`: the user decides when to install or upgrade. Report what `brew bundle check --no-upgrade` or `brew outdated` shows instead.

## Skills

- Create or convert skills with the `new-skill` skill in `skills/dotfiles/new-skill/`. It holds the front matter format, writes the files, adds the README entry and links the skill. Its `scripts/check-skills.sh` must pass.
- Add a third-party skill as a line in `scripts/skill-sources.sh`, pinned to a tag or full commit, then run `scripts/install-skills.sh`. Move pins only with `scripts/update-skills.sh`. Never run `skills add` or `npx skills` directly: without `-g`, it installs into this repo's `.agents/skills/`.
- Never edit an installed third-party skill: the next install replaces it. Copy it into `skills/dotfiles/` under a new name instead.
- Targets are flat, so skill names must be unique across this repo's skills and the third-party ones; the install script and `check-skills.sh` refuse a clash.
- `~/.claude/skills/synced/` belongs to the Claude app. Never touch it.
- Never add a `.agents/skills/` folder to the repo: pi and other Agent Skills clients load it as project skills when working here.

## Writing

- No em dashes anywhere: prose, docs, comments, commit messages.
- Each fact lives in one place. Docs record conventions, reasons and gotchas; they do not restate what files and commands already show.
- Change only what the task needs. Match the surrounding style and comment density.
- Write an ADR in `.agents/adr/` (`NNNN-slug.md`) only for a decision that is hard to reverse, surprising, and the result of a real trade-off.
- `AGENTS.md` is the only agent memory file. Do not add a `CLAUDE.md` or `CLAUDE.local.md` to the repo: Claude Code reads `AGENTS.md` only when neither exists.

## Never in this repo

The repo is public. Never commit:

- secrets, tokens, or files that hold them, such as `gh/hosts.yml`
- work content: employer names, hostnames, GitHub Enterprise hosts, ticket IDs or prefixes, work paths
- work-only tools and skills; they stay local, outside the repo. Where local settings go: [docs/machine-local.md](docs/machine-local.md)
- app state
- anything a shell writes under `$HOME`, such as `home/.cache` or `home/.ssh`; tests run shells in a temporary HOME

## Checks

After changes to zsh startup, `PATH` or mise, run the checks in [.agents/testing.md](.agents/testing.md).

After deploying, or when something seems off, run `scripts/doctor.sh`. It reports drift between the repo and `$HOME`, and must report no problems.
