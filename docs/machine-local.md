# What stays on a machine

The repo is public and shared by every machine, so some settings live only on the machine that needs them: identities, accounts, hosts, and work-only tools. None of these files is tracked; setup never overwrites them.

| What | Where | Started from |
|---|---|---|
| Git identities, accounts and hosts | `~/.gitconfig`, `~/.gitconfig-<identity>` | `.gitconfig-template`, copied once by `scripts/setup.sh`. See [git-identities.md](git-identities.md) |
| Which folder uses which gh login | `.envrc` in each identity folder | The example in [git-identities.md](git-identities.md) |
| Work-only Homebrew packages | Installed on the machine, kept out of `Brewfile` | `scripts/brew-dump-clean.sh` drops them when it regenerates the Brewfile |
| Shell aliases and functions | `~/.config/zsh/local.zsh` | The example below |
| A work-only tool's own settings | A plain file in the tool's folder, for example `~/.config/granted/config` | The tool writes it |
| `~/.config` folders whose names reveal work, so the doctor accepts them | `~/.config/dotfiles/local-config.txt`, in the format of `scripts/local-config.txt` | An empty file |

## Shell additions

`.zshrc` reads `~/.config/zsh/local.zsh` when it exists, at the end of its aliases. Agent shells never read it, so like every alias these exist only in human shells ([ADR 0007](../.agents/adr/0007-agent-shells-get-plain-tools.md)).

```sh
# ~/.config/zsh/local.zsh
# Granted: assume must run in this shell to set its AWS variables.
alias assume=". assume"
```

Keep `PATH` changes out of it: the order is built only in `.zsh/env.zsh` ([ADR 0004](../.agents/adr/0004-path-order-over-path-helper.md)). Environment variables a script or agent needs belong in a project's `.envrc` or `mise.toml`, not here.

`~/.config/zsh` must stay a real folder. If the repo ever tracks a file under `home/.config/zsh`, add `zsh` to `scripts/mixed-config-dirs.txt` first, or Stow links the whole folder and this file lands in the repo.
