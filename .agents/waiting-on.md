# Waiting on upstream

Fixes this repo wants but cannot make until another project ships something. Each entry has a check that prints `ready` once the fix is possible. When it does, make the fix, then delete the entry. Our own postponed decisions do not belong here.

## diffnav: added-line background differs from delta and hunk

- **Blocked on:** a diffnav release with `ui.useUserDeltaTheme`. It is merged on main (dlvhdr/diffnav#160) but not in any release; v0.13.1 is the latest.
- **Why it matters:** v0.13.1 colors diffs from its own theme and passes delta its own style flags, so added lines get `#212D20` instead of delta's `#394545`. The Colors rule in `AGENTS.md` wants the diff tools to match.
- **Check:**
  ```sh
  tag=$(gh api repos/dlvhdr/diffnav/releases/latest --jq .tag_name) &&
  curl -fsSL "https://raw.githubusercontent.com/dlvhdr/diffnav/$tag/README.md" | grep -q useUserDeltaTheme &&
  echo "ready: $tag" || echo "not yet: $tag"
  ```
  `ready` means a release has it; the installed diffnav (`diffnav --version`) must also be that version or later, and upgrading is the user's call.
- **Fix:** in `home/.config/diffnav/config.yml`, add `useUserDeltaTheme: true` under `ui:`, and drop `theme: catppuccin_mocha` if diffnav's UI still looks right without it. Compare a diff in diffnav and delta side by side.
