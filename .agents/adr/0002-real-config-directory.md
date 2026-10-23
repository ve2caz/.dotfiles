# 0002: Real ~/.config, track configuration and not app state

Status: accepted, 2026-10-22.

**Context.** `~/.config` was one folded link into the repo, so every tool wrote its app state, credential files included, into the working tree of a public repo. Only a `.gitignore` allowlist kept it out of git.

**Decision.** `~/.config` is a real directory. Folders holding only configuration are folded links. Mixed folders stay real, with file links for the tracked files. A generated default is app state until the user changes it.

**Alternatives rejected.** Keep the folded link and the allowlist: one wrong `!` line or `git add -f` publishes a credential. Stow with `--no-folding`: every nvim file becomes its own link, and new files in config-only folders need a restow.

**Consequences.** Tools that save by replacing a file break its link; check with `ls -la` after use. Tracking a new tool is an explicit choice. `.gitignore` no longer needs an allowlist. Untracked tool settings are not backed up by the repo.
