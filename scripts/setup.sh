#!/bin/bash
# Bootstraps a Mac: packages, the home package, the bat theme and skills. Safe to rerun.
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

themes="$HOME/.config/bat/themes"
if [ ! -f "$themes/tokyonight_night.tmTheme" ]; then
    mkdir -p "$themes"
    curl -fsSL -o "$themes/tokyonight_night.tmTheme" https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/tokyonight_night.tmTheme
    bat cache --build
fi

./scripts/update-skills.sh
