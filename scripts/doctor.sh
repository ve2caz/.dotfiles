#!/bin/bash
# Reports drift between this repo and the deployed $HOME. Read-only: it never changes anything.

REPO="$(cd "$(dirname "$0")/.." && pwd)"
problems=0

pass() { echo "✅ $1"; }
fail() {
    echo "❌ $1"
    printf '%s\n' "$2" | sed 's/^/   /'
    problems=$((problems + 1))
}

echo "🩺 .dotfiles doctor ($REPO)"
echo ""

# Untracked or ignored files under home/ are app state that a tool wrote into the repo.
stray="$(git -C "$REPO" status --porcelain --ignored --untracked-files=all -- home | grep -E '^(\?\?|!!)')"
if [ -z "$stray" ]; then
    pass "No untracked or ignored files under home/"
else
    fail "Files under home/ that git does not track (app state written into the repo):" "$stray"
fi

# An already-stowed package makes the dry run print only its simulation warning.
drift="$(stow -n -v -d "$REPO" -t "$HOME" home 2>&1 | grep -v 'in simulation mode')"
if [ -z "$drift" ]; then
    pass "\$HOME matches the home package"
else
    fail "\$HOME differs from the home package (missing link, replaced file link, or conflict):" "$drift"
fi

for dir in "$HOME/.config" "$HOME/.claude/skills" "$HOME/.agents/skills"; do
    if [ -L "$dir" ]; then
        fail "$dir is a link; it must be a real directory" "$(ls -l "$dir")"
    elif [ "$dir" = "$HOME/.config" ] && [ ! -d "$dir" ]; then
        fail "$dir is missing; it must be a real directory" "mkdir ~/.config, then restow"
    else
        pass "$dir is not a link"
    fi
done

while read -r d; do
    if [ -L "$HOME/.config/$d" ] || [ ! -d "$HOME/.config/$d" ]; then
        fail "$HOME/.config/$d must be a real directory; it mixes config and app state" "$(ls -ld "$HOME/.config/$d" 2>&1)"
    else
        pass "$HOME/.config/$d is a real directory"
    fi
done < "$REPO/scripts/mixed-config-dirs.txt"

# Without a real ~/.gitconfig, git config --global writes into the repo through the link.
if [ -f "$HOME/.gitconfig" ] && [ ! -L "$HOME/.gitconfig" ]; then
    pass "$HOME/.gitconfig is a real file"
else
    fail "$HOME/.gitconfig must be a real file; it holds this machine's identities" \
        "cp $REPO/.gitconfig-template ~/.gitconfig, then fill it in: docs/git-identities.md"
fi

# env.zsh writes out what `brew shellenv` prints. A Homebrew update that prints other names or
# values must be copied into env.zsh.
brew_bin=""
for b in /opt/homebrew/bin/brew /usr/local/Homebrew/bin/brew; do [ -x "$b" ] && { brew_bin=$b; break; }; done
if [ -n "$brew_bin" ]; then
    names="$("$brew_bin" shellenv zsh | grep -oE '[A-Za-z_]+(\[1,0\])?=' | LC_ALL=C sort -u | tr '\n' ' ')"
    known='HOMEBREW_CELLAR= HOMEBREW_PREFIX= HOMEBREW_REPOSITORY= INFOPATH= MANPATH= PATH= fpath[1,0]= '
    # shellcheck disable=SC2016 # expanded by the shells below, not here
    show='printf "%s\n" "$HOMEBREW_PREFIX" "$HOMEBREW_CELLAR" "$HOMEBREW_REPOSITORY" "$INFOPATH"'
    want="$(env -i HOME="$HOME" PATH=/usr/bin:/bin /bin/bash -c "eval \"\$(\"$brew_bin\" shellenv bash)\"; $show")"
    got="$(env -i HOME="$HOME" PATH=/usr/bin:/bin zsh -c "$show" </dev/null 2>/dev/null)"
    if [ "$names" = "$known" ] && [ "$want" = "$got" ]; then
        pass "env.zsh matches brew shellenv"
    else
        fail "env.zsh differs from brew shellenv; update its Homebrew block" "brew shellenv sets: $names
env.zsh handles:     $known
brew shellenv values: ${want//$'\n'/ }
env.zsh values:       ${got//$'\n'/ }"
    fi
fi

broken="$({
    find "$HOME" -maxdepth 1 -type l -lname '*dotfiles*' ! -exec test -e {} \; -print
    find "$HOME/.config" -maxdepth 2 -type l -lname '*dotfiles*' ! -exec test -e {} \; -print
    find "$HOME/.claude/skills" "$HOME/.agents/skills" -maxdepth 1 -type l ! -exec test -e {} \; -print
} 2>/dev/null)"
if [ -z "$broken" ]; then
    pass "No broken links into the repo or the skill folders"
else
    fail "Links that point at nothing:" "$broken"
fi

if skills_out="$("$REPO/skills/dotfiles/new-skill/scripts/check-skills.sh" 2>&1)"; then
    pass "Skills in skills/dotfiles pass check-skills"
else
    fail "check-skills found problems:" "$skills_out"
fi

echo ""
if [ "$problems" -eq 0 ]; then
    echo "🎉 No problems found"
else
    echo "⚠️  $problems problem(s) found"
    exit 1
fi
