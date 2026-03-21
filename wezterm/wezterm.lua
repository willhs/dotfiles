------
-- based on youtube / gh: mplusp
-- https://github.com/mplusp/dotfiles/blob/main/wezterm/.config/wezterm/wezterm.lua
------

local wezterm = require("wezterm")

-- Initialize actual config
local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- appearance
config.font = wezterm.font('MonaspiceAr Nerd Font')
config.font_rules = {
  {
    intensity = 'Bold',
    font = wezterm.font('MonaspiceAr Nerd Font', { weight = 900 }),
  },
  {
    intensity = 'Bold',
    italic = true,
    font = wezterm.font('MonaspiceAr Nerd Font', { weight = 900, italic = true }),
  },
}
config.font_size = 13.0
-- config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.macos_window_background_blur = 10
-- config.color_scheme = color_scheme_for_appearance(wezterm.gui.get_appearance())
-- config.use_fancy_tab_bar - false
-- config.native_macos_fullscreen_mode = false

config.keys = {
  {
    key = '_',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" })
  },
  {
    key = '?',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" })
  },
  {
    key = "Enter",
    mods = "SHIFT",
    action = wezterm.action.SendString("\n"),
  },

  {
    key = 'F20',
    action = wezterm.action.Nop
  },
  -- Show pane titles
  { key = 's', mods = 'CMD', action = wezterm.action.EmitEvent('show-pane-titles') },
  -- Pane navigation
  { key = 'h', mods = 'CMD|SHIFT', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'CMD|SHIFT', action = wezterm.action.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'CMD|SHIFT', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'CMD|SHIFT', action = wezterm.action.ActivatePaneDirection 'Right' },
}

local function scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return "Tokyo Night Storm"       -- other good options: "GruvboxDark", "Catppuccin Mocha", "OneDark (base16)"
  else
    return "Tokyo Night Day"         -- pick any light you like
  end
end

-- if wezterm.gui then
  -- config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())
-- else
  -- config.color_scheme = "Tokyo Night Storm"
-- end

-- unbind f20...
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- Dim inactive panes
config.inactive_pane_hsb = { brightness = 0.7 }

-- Pass the window-focus click through to tmux so a single click
-- both focuses the window and selects the tmux pane.
config.swallow_mouse_click_on_window_focus = false

-- Capture the user's full shell PATH so panes spawned from minimal-env contexts
-- (e.g. launchd services calling `wezterm cli split-pane`) get the right PATH.
-- Without this, tools like pyenv/nvm aren't available and Claude Code's MCP
-- servers fail to start because they find the wrong python3.
local success, full_path = wezterm.run_child_process({"zsh", "-ic", "echo $PATH"})
if success and full_path then
  full_path = full_path:gsub("%s+$", "")  -- trim trailing whitespace
  config.set_environment_variables = { PATH = full_path }
end

return config
