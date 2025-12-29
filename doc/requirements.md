# Requirements

## macOS

### XCode CLI tools

This will install the developer CLI tools including git.

⚠️ **Warning:** Homebrew depends on some of these tools!

```zsh
xcode-select --install
```

### Homebrew

This is a popular package manager for macOS.
The following command will open a browser to this site.
Follow the instructions to install homebrew.

```
open -a "Safari" "https://brew.sh"
```

## Linux

Only Debian/Ubuntu-based systems are fully supported by this repository.

Most distributions come with git pre-installed. If not:

```bash
# Ubuntu/Debian
sudo apt update && sudo apt install git direnv
```

Note: For other Linux distributions, refer to `scripts/install-packages.sh` for package guidance or install equivalents manually.
