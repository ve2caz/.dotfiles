# .dotfiles
This directory contains the dotfiles for a basic dev environment

## Requirements

Ensure you have the following installed on your system

### XCode CLI tools

This will install the developer CLI tools including git.
Homebrew depends on some of these tools!

```zsh
xcode-select --install
```

### Homebrew

The is a popular package manager for MacOS.
The following command will open a browser to this site.
Follow the instructions to install homebrew.

```
open -a "Safari" "https://brew.sh"
```

### GNU stow

Organize software configuration neatly under a single directory tree (e.g. ~/.dotfiles)

```
brew install stow
```

## Installation

First, check out the .dotfiles repo in your $HOME directory using git

```
$ cd ~
$ git clone git@github.com/ve2caz/.dotfiles.git
$ cd .dotfiles
```

Now use GNU stow to create symlinks

```
$ stow .
```

## Install the rest of the tooling using Brewfile

```
brew bundle
```

