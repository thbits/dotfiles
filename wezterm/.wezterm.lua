local wezterm = require 'wezterm'
local act = wezterm.action
local mux = wezterm.mux

-- Use the configuration builder if available
local config = wezterm.config_builder and wezterm.config_builder() or {}

-- =======================
-- General Settings
-- =======================
config.color_scheme = 'Catppuccin Mocha'           -- Color scheme
config.font_size = 9.1                               -- Font size
config.freetype_load_target = "HorizontalLcd"      -- Font rendering optimization
config.hide_tab_bar_if_only_one_tab = true         -- Hide tab bar if only one tab
config.disable_default_key_bindings = true         -- Disable default key bindings
config.default_domain = 'WSL:Ubuntu'               -- Default domain for WSL2 Ubuntu
config.audible_bell = "Disabled"                   -- Disable error sounds
config.swallow_mouse_click_on_window_focus = true
config.hide_mouse_cursor_when_typing = false
config.freetype_load_target = "Light"
config.freetype_load_flags = "NO_HINTING"
config.window_background_opacity = 1
config.line_height = 0.9
-- =======================
-- Animation and Rendering
-- =======================
config.animation_fps = 240                          -- Set refresh rate to 240 FPS
max_fps = 240

-- =======================
-- Foreground Settings
-- =======================
config.foreground_text_hsb = {
  hue = 1.0,
  saturation = 1.0,
  brightness = 1,
}

-- =======================
-- Font Settings
-- =======================
config.font = wezterm.font {
  family = 'CaskaydiaCove NFM',
  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
}

-- =======================
-- Key Bindings
-- =======================
config.keys = {
  { key = 'Insert', mods = 'SHIFT', action = act.PasteFrom 'Clipboard' }, -- Paste with Shift+Insert
}

-- =======================
-- Mouse Bindings
-- =======================
config.mouse_bindings = {
  -- Right-click to paste from clipboard
  {
    event = { Down = { streak = 1, button = "Right" } },
    mods = "NONE",
    action = act.PasteFrom 'Clipboard',
  },
  -- Triple-click to select semantic zone
  {
    event = { Down = { streak = 3, button = "Left" } },
    mods = "NONE",
    action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
  },
  -- Right-click with text selection logic
  {
    event = { Down = { streak = 1, button = "Right" } },
    mods = "NONE",
    action = wezterm.action_callback(function(window, pane)
      local has_selection = window:get_selection_text_for_pane(pane) ~= ""
      if has_selection then
        window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
        window:perform_action(act.ClearSelection, pane)
      else
        window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
      end
    end),
  },
}

-- =======================
-- Launch Menu (Placeholder)
-- =======================
config.launch_menu = {}

return config