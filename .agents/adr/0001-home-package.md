# 0001: Deploy only home/ to $HOME

Status: accepted, 2026-10-22.

**Context.** The repo root was the Stow package. Every repo-only name (docs, scripts, agent files, `Brewfile`) had to be listed in the root `.stow-local-ignore`, and a path alone did not say whether a file deploys.

**Decision.** `home/` is the only package for `$HOME`. The repo root holds only repo-only files.

**Alternative rejected.** Keep the root as the package and move agent docs into `docs/agents/` and `docs/adr/`. Smaller change, but the ignore list stays and must track every new root file.

**Consequences.** Deployed paths gain a `home/` prefix, so scripts, tests and docs changed, and the live `$HOME` was unstowed and restowed once. Root dot-folders such as `.agents/` remain and are flagged in GLOSSARY.md.
