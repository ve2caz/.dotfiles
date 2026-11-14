#!/bin/bash
# Regenerates the Brewfile from what is installed, without work-only tools: they stay local.
set -euo pipefail
cd "$(dirname "$0")/.."

# Only taps, formulae and casks; add --mas to include Mac App Store apps. Listing other package
# types (npm, uv, Go, Cargo) runs those tools through the mise shims, which fail outside a project.
brew bundle dump --force --tap --formula --cask

# Work-only taps and formulae. Each goes with the description comment Homebrew writes above it.
work_only='^(tap "atlassian/acli"|brew "atlassian/acli/acli"|brew "awscli"|tap "fwdcloudsec/granted"|brew "fwdcloudsec/granted/granted")'
awk -v work_only="$work_only" '
    /^#/ { held = held $0 "\n"; next }
    $0 ~ work_only { held = ""; next }
    { printf "%s", held; held = ""; print }
    END { printf "%s", held }
' Brewfile > Brewfile.tmp
mv Brewfile.tmp Brewfile
echo "Brewfile updated, work-only entries removed."
