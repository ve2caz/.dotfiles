#!/bin/bash
# Generate Brewfile without VS Code extensions
brew bundle dump --force --describe --no-vscode
# Remove Atlassian CLI entries
# The .brewignore functionality isn't working properly
sed -i '' '/^tap "atlassian\/acli"/d' Brewfile
sed -i '' '/^# Software to interact with Atlassian Cloud from the terminal/d' Brewfile
sed -i '' '/^brew "atlassian\/acli\/acli"/d' Brewfile
echo "Brewfile updated, Atlassian CLI entries removed."
