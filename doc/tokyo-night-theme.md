# 🎨 Tokyo Night Theme Guide

This dotfiles configuration uses the **Tokyo Night** theme consistently across all tools for a unified, modern dark theme experience, while following XDG Base Directory Specification for clean organization.

## Theme Overview

Tokyo Night is a clean, dark theme with:
- **Background**: Deep navy blue (#1a1b26)
- **Primary**: Soft blue (#7aa2f7)
- **Accent colors**: Purple (#bb9af7), cyan (#7dcfff), green (#9ece6a)
- **Text**: Light blue-white (#c0caf5)

## XDG Base Directory Compliance

All theme files and configurations are stored according to XDG standards:
- **Config files**: `$XDG_CONFIG_HOME` (default: `~/.config`)
- **Data files**: `$XDG_DATA_HOME` (default: `~/.local/share`)
- **Cache files**: `$XDG_CACHE_HOME` (default: `~/.cache`)

## Tools Using Tokyo Night

| Tool | Theme/Configuration | Status |
|------|-------------------|---------|
| **WezTerm** | Custom Tokyo Night colorscheme | ✅ Configured |
| **bat** | `tokyonight_night.tmTheme` | ✅ Auto-downloads |
| **btop** | `tokyo-night` theme | ✅ Configured |
| **yazi** | `tokyo-night` flavor | ✅ Configured |
| **tmux** | Powerline blue (Tokyo Night compatible) | ✅ Configured |
| **Starship** | Tokyo Night theme | ✅ Configured |
| **htop** | Color scheme 6 (compatible) | ✅ Configured |

## Setup

Run the theme setup script to ensure all themes are properly installed with XDG compliance:

```bash
./scripts/setup-tokyo-night-theme.sh
```

This script will:
- Set up all XDG environment variables
- Install themes to appropriate XDG directories
- Ensure consistent configuration across all tools

## Color Reference

The central color configuration is stored in `.config/colors/tokyo-night.conf` for reference when customizing additional tools.

## Directory Structure

Following XDG Base Directory Specification:

```
$XDG_CONFIG_HOME/
├── bat/themes/           # bat syntax highlighting themes
├── btop/                 # btop system monitor config
├── yazi/flavors/         # yazi file manager themes
├── colors/               # central color definitions
└── starship.toml         # stasrship config

$XDG_DATA_HOME/
├── zinit/                # zsh plugin manager data
├── tmux/plugins/         # tmux plugins
└── fzf-git/              # fzf-git integration
```

## Customization

To add Tokyo Night theming to new tools:
1. Check if a Tokyo Night variant exists for the tool
2. Reference colors from `.config/colors/tokyo-night.conf`
3. Update the setup script to include the new tool
4. Update this documentation

## Screenshots

The unified theme provides:
- Consistent dark backgrounds across all terminal applications
- Harmonious blue-purple accent colors
- Excellent readability with proper contrast ratios
- Professional, modern appearance
