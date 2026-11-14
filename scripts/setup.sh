#!/bin/bash
# Bootstraps a Mac: packages, the home package and skills. Safe to rerun.
set -euo pipefail
cd "$(dirname "$0")/.."

command -v brew >/dev/null || { echo "Install Homebrew first: https://brew.sh" >&2; exit 1; }
brew bundle

data="${XDG_DATA_HOME:-$HOME/.local/share}"
[ -d "$data/zinit/zinit.git" ] || git clone https://github.com/zdharma-continuum/zinit.git "$data/zinit/zinit.git"
[ -d "$data/fzf-git" ] || git clone https://github.com/junegunn/fzf-git.sh.git "$data/fzf-git"

# lnav writes to ~/.lnav unless ~/.config/lnav exists. A second lnav -i of the same repo fails.
if [ ! -d "$HOME/.config/lnav/formats/installed" ]; then
    mkdir -p "$HOME/.config/lnav"
    lnav -i https://github.com/shoffmeister/lnav-formats.git
fi

while read -r d; do mkdir -p "$HOME/.config/$d"; done < scripts/mixed-config-dirs.txt
stow -t "$HOME" home

# ~/.gitconfig holds this machine's identities and accounts, so it is copied once and never
# overwritten. Until it exists, git config --global writes into the repo through the link.
if [ ! -e "$HOME/.gitconfig" ]; then
    cp .gitconfig-template "$HOME/.gitconfig"
    echo "Created ~/.gitconfig from the template: fill it in, see docs/git-identities.md."
fi

# Links this repo's skills, then installs everyone else's at the pins in scripts/skill-sources.sh.
mise trust --quiet "$PWD/mise.toml"
mise install
./scripts/link-skills.sh
./scripts/install-skills.sh
