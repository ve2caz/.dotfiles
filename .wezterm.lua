-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Get the directory where this config file is located
local config_dir = wezterm.config_dir

-- Function to detect if window is fullscreen
local function is_fullscreen(window)
  return window:get_dimensions().is_full_screen
end

-- Config choices

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 15

config.enable_tab_bar = false

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.8
config.macos_window_background_blur = 10

-- Window sizing options
config.initial_cols = 125  -- Width in characters
config.initial_rows = 45   -- Height in characters

-- Event handler for window state changes
wezterm.on('window-resized', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  
  if window:get_dimensions().is_full_screen then
    -- Fullscreen: show background image with same transparency as windowed mode
    overrides.background = {
      {
        source = {
          File = config_dir .. "/.wezterm/ai-generated-8136169_1280.png",
        },
        hsb = {
          hue = 1.0,
          saturation = 1.0,
          brightness = 0.2,  -- Increased brightness for lighter image
        },
        width = "100%",
        height = "100%",
        opacity = 0.3,  -- Much lower opacity for more transparency
      },
    }
    -- Keep the same window opacity and blur settings
    overrides.window_background_opacity = 0.8
    overrides.macos_window_background_blur = 10
  else
    -- Windowed mode: no background image
    overrides.background = nil
  end
  
  window:set_config_overrides(overrides)
end)

-- my coolnight colorscheme:
config.colors = {
	foreground = "#CBE0F0",
	background = "#011423",
	cursor_bg = "#47FF9C",
	cursor_border = "#47FF9C",
	cursor_fg = "#011423",
	selection_bg = "#033259",
	selection_fg = "#CBE0F0",
	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
}

-- and finally, return the configuration to wezterm
return config
