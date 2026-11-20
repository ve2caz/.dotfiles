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

## superfile: images in herdr need a TERM_PROGRAM override

- **Blocked on:** a superfile release that picks Kitty graphics without its `TERM_PROGRAM`/`TERM` allowlist (`isKittyCapable` in `src/pkg/file_preview/kitty.go`), or that lists herdr. v1.6.0 has the allowlist, and its code says it should become a real capability check.
- **Why it matters:** herdr renders Kitty graphics, but superfile does not know herdr, so `.zshrc` aliases `spf` to `TERM_PROGRAM=ghostty spf` in herdr panes. Without it, images are colored half-blocks.
- **Check:**
  ```sh
  tag=$(gh api repos/yorukot/superfile/releases/latest --jq .tag_name) &&
  src=$(curl -fsSL "https://raw.githubusercontent.com/yorukot/superfile/$tag/src/pkg/file_preview/kitty.go") &&
  { printf '%s' "$src" | grep -q knownTerminals && ! printf '%s' "$src" | grep -qi herdr && echo "not yet: $tag" || echo "ready: $tag"; } ||
  echo "check by hand: kitty.go moved in $tag"
  ```
  `ready` needs the installed superfile (`spf --version`) at that version or later; upgrading is the user's call.
- **Fix:** drop the `herdr)` line of the `spf` alias in `home/.zshrc`. A real capability check also defeats the `WezTerm)` line, which hides WezTerm from the allowlist: WezTerm answers the Kitty query, so superfile would send it images it cannot place (next entry). Until that entry is ready, find another way to keep WezTerm on the half-block fallback, or accept broken images there.

## superfile: blocky images in plain WezTerm

- **Blocked on:** either a superfile release with an image protocol WezTerm can place (iTerm2 inline images or sixel), or a WezTerm release that supports Kitty Unicode placeholders (`U=1`). superfile v1.6.0 only sends Kitty graphics with Unicode placeholders, and WezTerm 20240203-110809-5046fc22 reads no `U` key (`termwiz/src/escape/apc.rs`).
- **Why it matters:** outside herdr, `.zshrc` aliases `spf` to `TERM_PROGRAM= spf` so superfile uses its half-block fallback instead of Kitty images that break the screen. yazi (`fm`) shows real images there through iTerm2 inline images.
- **Check:**
  ```sh
  tag=$(gh api repos/yorukot/superfile/releases/latest --jq .tag_name) &&
  gh api "repos/yorukot/superfile/git/trees/$tag?recursive=1" --jq '.tree[].path' |
  grep -qiE 'file_preview/.*(iterm|sixel)' && echo "ready: superfile $tag" || echo "not yet: superfile $tag"
  tag=$(gh api repos/wezterm/wezterm/releases/latest --jq .tag_name) &&
  curl -fsSL "https://raw.githubusercontent.com/wezterm/wezterm/$tag/termwiz/src/escape/apc.rs" |
  grep -qE 'keys, "U"' && echo "ready: wezterm $tag" || echo "not yet: wezterm $tag"
  ```
  Either `ready` is enough, with the installed version (`spf --version`, `wezterm --version`) at that release or later.
- **Fix:** drop the `WezTerm)` line of the `spf` alias in `home/.zshrc`, then check an image in `spf` in a plain WezTerm tab. If superfile gained a new protocol but still picks Kitty for WezTerm, set its config to the new one instead.
