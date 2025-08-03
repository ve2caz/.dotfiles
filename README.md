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

## Deploy the shell configuration

First, check out the .dotfiles repo in your $HOME directory using git

```
$ cd ~
$ git clone git@github.com/ve2caz/.dotfiles.git
$ cd .dotfiles
```

## Install the rest of the tooling using Brewfile

```
$ brew bundle
```

From the .dotfiles folder, use GNU stow to create symlinks activating the configuration

```
$ stow .
```
