-- Only settings that differ from the defaults. Defaults: https://wezterm.org/config/lua/config/
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()
local config_dir = wezterm.config_dir

-- Config choices
config.enable_tab_bar = false
config.scrollback_lines = 5000
config.window_decorations = "RESIZE"

-- Background
config.background = {
  {
    source = { File = config_dir .. "/ai-generated-8136169_1280.png" },
    hsb = { hue = 1.0, saturation = 1.0, brightness = 0.03 },
    vertical_align = "Middle",
    horizontal_align = "Center",
  }
}

-- Font choices
config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 15

-- The one palette: tools that use the 16 terminal colors follow it.
config.color_scheme = "Catppuccin Mocha"

-- Free WezTerm's Ctrl font-size and tab shortcuts that hide zsh undo (Ctrl+- / Ctrl+_) and
-- set mark (Ctrl+Shift+2). Cmd+- , Cmd+0 and Cmd+1..9 still do the same jobs.
local free = wezterm.action.DisableDefaultAssignment
config.keys = {
  { key = "-", mods = "CTRL", action = free },
  { key = "-", mods = "SHIFT|CTRL", action = free },
  { key = "_", mods = "CTRL", action = free },
  { key = "_", mods = "SHIFT|CTRL", action = free },
  { key = "2", mods = "SHIFT|CTRL", action = free },
  { key = "@", mods = "CTRL", action = free },
  { key = "@", mods = "SHIFT|CTRL", action = free },
}

return config
