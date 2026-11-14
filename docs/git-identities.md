# Git identities and GitHub accounts

How to run several identities on one Mac, with `git` and `gh` acting as the right one without switching by hand. The same setup works on a personal and a work machine. Names, emails, accounts and hosts stay in untracked files, so the dotfiles repo can be public.

## Hosts, accounts and identities

- **Hosts.** github.com, and on a work machine a GitHub Enterprise host.
- **Accounts.** github.com has a personal account and a work account, kept apart on purpose: each reaches only its own organizations. The Enterprise host has a work account.
- **Identities.** An identity is a commit name and email plus the account it uses. Personal is one; work may be two, when the work github.com account commits with a different email than the Enterprise account.

On github.com the host cannot tell personal from work, and before a remote exists neither can the URL. The folder a repo lives in can, so on github.com the folder chooses the identity. The Enterprise host has only the work account, so the host alone chooses its credentials.

## The layers

Git reads its configuration files in this order, and the last value found wins:

| File | Tracked | Holds |
|---|---|---|
| `/opt/homebrew/etc/gitconfig` | No, Homebrew's | Homebrew's keychain credential helper |
| `~/.config/git/config` | Yes, `home/.config/git/config` | Settings every machine shares, and the rules that remove defaults |
| `~/.gitconfig` | No, copied once from `.gitconfig-template` | Which folders get which identity, the Enterprise host's credentials, lines tools write |
| `~/.gitconfig-<identity>` | No | One identity: name, email, and its account on each host |
| `.git/config` in a repo | No | That repo's remotes and branches |

`~/.gitconfig` pulls in an identity file with `includeIf "gitdir:<folder>/"` for repos in that folder. `scripts/setup.sh` copies the template only when `~/.gitconfig` is missing, so it never touches a machine's real file. The template's comments list every placeholder.

`~/.gitconfig` must exist, and `scripts/doctor.sh` reports it when it does not. Without it, `git config --global` writes to `~/.config/git/config`, which is a link into the repo. `~/.config/git` is in `scripts/mixed-config-dirs.txt` for the same reason: only the `config` file is linked.

Tools that run `git config --global` write to `~/.gitconfig`. Examples are `git lfs install`, which adds its `filter "lfs"` section, and editors that set `core.editor`. Keep or remove those lines there; they never reach the repo.

## No defaults

Outside a folder that sets an identity, git has none, on purpose:

- **Commits fail.** `user.useConfigOnly` stops git from guessing a name and email from the machine: `fatal: no email was given and auto-detection is disabled`.
- **github.com authentication fails.** The shared config removes Homebrew's keychain helper for github.com and gist.github.com. `credential.interactive = false` stops git from prompting: `fatal: unable to get password from user`. Public repos still clone, because they need no credentials.
- **gh has no account.** gh's default config folder, `~/.config/gh`, holds no login, so gh answers `To get started with GitHub CLI, please run: gh auth login`.

The Enterprise host is the exception: it authenticates anywhere, as its only account. See [The Enterprise host goes by host](#the-enterprise-host-goes-by-host).

A repo in the wrong place fails loudly instead of committing or pushing as the wrong account. Move it into the right folder.

`credential.interactive = false` applies to every host, not only GitHub. A host that needs a typed password needs a credential helper of its own.

## Folders choose the identity

Each rule in `~/.gitconfig` names a folder and an identity file. The rule matches the repo's git dir, so:

- **A clone already gets its folder's identity.** `git clone` into the folder asks for that folder's account.
- **Worktrees follow their main checkout.** A worktree's git dir sits inside the main repo, for example `~/.dotfiles/.git/worktrees/<name>`, so the rule for `~/.dotfiles/` covers every dotfiles worktree.
- **A repo outside the project folders needs its own rule.** The template has one for `~/.dotfiles/`, which lives directly under `~`.

## The Enterprise host goes by host

Only the work account uses the Enterprise host, so `~/.gitconfig` sets its account and helper for the host itself, not in an identity file. Clones that tools make outside every folder, such as the modules Tilt fetches into `~/.local/share`, then still authenticate. Commits there still fail: the commit identity comes only from a folder.

github.com cannot work this way, because both accounts share the host.

## One gh login per account

Each side keeps its gh logins in its own gh config folder: `~/.config/gh-personal` for the personal account, `~/.config/gh-work` for both work accounts, which sit on different hosts. gh stores the tokens in the macOS keychain, not in those folders.

Git gets its credentials from gh. Every github.com identity file, and the Enterprise host section, has two settings: `username`, the account, and `helper`, which runs `gh auth git-credential` with `GH_CONFIG_DIR` set to that identity's folder. Both are needed:

- **The account name** makes gh return that account's token and nothing else. Asked for an account it does not hold, gh returns nothing.
- **The config folder** is what makes gh honor the account name. gh also keeps a keychain entry for the last account that logged in on each host. With a config folder that lists no accounts, gh returns that entry whatever account git asks for. That would be a silent default.

The helper calls gh by its full path, `/opt/homebrew/bin/gh`, because apps started from the Dock, such as an IDE, may not have Homebrew on their `PATH`.

Remotes with SSH URLs are rewritten to HTTPS by `url.<base>.insteadOf` in `~/.gitconfig`, so they use the same login. Git needs no SSH keys.

## gh follows the folder through direnv

gh does not read git's configuration, so it needs its own way to pick the identity. A `.envrc` file in each identity folder sets the gh config folder:

```sh
# ~/dev/work-github/.envrc
export GH_CONFIG_DIR="$HOME/.config/gh-work"
```

Run `direnv allow` in the folder once. The `.envrc` files are local; none is in the repo.

A gh config folder with at least one login also reaches hosts it does not list: gh falls back to the keychain's last token for that host. From a personal folder, `gh api --hostname github.example.com` therefore acts as the Enterprise account, which matches the host rule above. Both gh folders list github.com, so github.com never falls back. gh's default folder holds no login, so outside every folder gh stops before the keychain.

direnv acts when an interactive zsh shows a prompt or changes folder. That covers terminals, herdr panes, IDE terminals and agent shells that run an interactive zsh, such as Cursor's. Scripts and other non-interactive shells do not get it. There gh finds no login and fails, the safe direction. Name the folder for one command when needed:

```sh
GH_CONFIG_DIR=~/.config/gh-work gh pr list
```

For the dotfiles repo, put the `.envrc` in the repo and keep it out of git with the repo's local ignore file, `.git/info/exclude`.

## What follows the folder

| Program | Follows the folder | How |
|---|---|---|
| `git`, including `git clone` | Yes | The identity file sets the account and the helper |
| `gh` in an interactive shell | Yes | direnv sets the gh config folder |
| `git` on the Enterprise host | Not needed | `~/.gitconfig` sets its credentials for the host |
| `gh` in a script | No, fails | No direnv; set `GH_CONFIG_DIR` for the command |
| VS Code, Cursor | Yes, for git | They run the system git, which reads these files |
| GitHub Desktop | No | It has its own sign-in |

GitHub Desktop runs its own bundled git and turns off other credential helpers for its operations. It holds one github.com account and one Enterprise account, so it can act as only one of the two github.com accounts. Sign it in to the account used most in Desktop, and use the command line or an IDE for the other.

IDE features that call GitHub directly, such as pull request panels, use the IDE's own GitHub sign-in, not gh.

## Setting up a machine

1. **Run `scripts/setup.sh`.** It deploys the shared config and, when `~/.gitconfig` is missing, copies the template there. If `~/.gitconfig` already exists, merge the template into it by hand.
2. **Fill in `~/.gitconfig`.** Replace the placeholders with this machine's folders and hosts. Delete the Enterprise sections on a machine without one.
3. **Create the identity files** from the blocks at the end of the template, with your names, emails and account names. One work identity file is enough when both work accounts commit with the same email: point both work folders at it.
4. **Log in to each account in a browser**, with two-factor authentication. Run the command in a terminal, not through an agent: gh prints a one-time code there, which you type on GitHub's device page.

   ```sh
   GH_CONFIG_DIR=~/.config/gh-personal gh auth login --web --hostname github.com --git-protocol https
   GH_CONFIG_DIR=~/.config/gh-work gh auth login --web --hostname github.com --git-protocol https
   GH_CONFIG_DIR=~/.config/gh-work gh auth login --web --hostname github.example.com --git-protocol https
   ```

   When gh asks "Authenticate Git with your GitHub credentials?", answer no. Yes would add a helper without an account name to `~/.gitconfig`, which is a default.

   If `~/.config/gh/hosts.yml` exists from an earlier plain `gh auth login`, move it aside so gh's default folder holds no login. Do not run `gh auth logout` there: logout removes the account's token from the keychain, which the identity folders share.
5. **Add a `.envrc` to each identity folder** and run `direnv allow` there.
6. **Check each folder.** These print no secrets:

   ```sh
   git -C <repo> config user.email   # the folder's email
   git -C <repo> ls-remote origin >/dev/null && echo authenticated
   gh auth status                    # from inside the folder: the folder's account
   ```

   From a repo outside every folder, all three should fail.

## Troubleshooting

| Message | Cause |
|---|---|
| `fatal: no email was given and auto-detection is disabled` | The repo is outside every identity folder. |
| `fatal: unable to get password from user` | Outside every identity folder, the identity file has no section for this host, or the gh folder has no login for the account. |
| `remote: Repository not found.` | The folder's account has no access: the repo belongs to the other identity. |
| `To get started with GitHub CLI, please run: gh auth login` | No `.envrc` in the folder, it is not allowed yet, or the shell is non-interactive. |
| Desktop pushes as the wrong account | Expected: Desktop has its own single github.com sign-in. |
