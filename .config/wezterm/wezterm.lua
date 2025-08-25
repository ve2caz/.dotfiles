-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()
local config_dir = wezterm.config_dir

-- Config choices
config.enable_tab_bar = false
config.automatically_reload_config = true
config.scrollback_lines = 5000
config.window_background_opacity = 1
config.window_decorations = "RESIZE"

-- Background
config.background = {
  {
    source = { File = config_dir .. "/ai-generated-8136169_1280.png" },
    hsb = { hue = 1.0, saturation = 1.0, brightness = 0.03 },
    vertical_align = "Middle",
    horizontal_align = "Center",
    opacity = 1
  }
}

-- Font choices
config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 15

-- Tokyo Night colorscheme for consistency across tools
config.colors = {
	foreground = "#c0caf5",
	background = "#1a1b26",
	cursor_bg = "#c0caf5",
	cursor_border = "#c0caf5",
	cursor_fg = "#1a1b26",
	selection_bg = "#283457",
	selection_fg = "#c0caf5",
	ansi = { "#15161e", "#f7768e", "#9ece6a", "#e0af68", "#7aa2f7", "#bb9af7", "#7dcfff", "#a9b1d6" },
	brights = { "#414868", "#f7768e", "#9ece6a", "#e0af68", "#7aa2f7", "#bb9af7", "#7dcfff", "#c0caf5" },
}

-- and finally, return the configuration to wezterm
return config
