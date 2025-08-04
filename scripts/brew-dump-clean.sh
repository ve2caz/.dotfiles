#!/bin/bash
# Generate Brewfile without VS Code extensions
brew bundle dump --force --describe --no-vscode
echo "Brewfile updated excluding VS Code extensions."
