local wezterm = require 'wezterm'
local config = {}
local act = wezterm.action

--Better debug, config build
if wezterm.config_builder then
  config = wezterm.config_builder()
end
---Start Building config

config.debug_key_events = true
config.check_for_updates = false
config.native_macos_fullscreen_mode = true
config.default_cwd = wezterm.home_dir
config.audible_bell="Disabled"
config.front_end = "OpenGL"
config.enable_kitty_graphics=true
config.automatically_reload_config = true

--function to check OS mode, and set theme--
function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'Gruvbox dark, hard (base16)'
  else
    return 'Gruvbox light, hard (base16)'
  end
end

--Better debug, config build
--if wezterm.config_builder then
--  config = wezterm.config_builder()
--end
--config.debug_key_events = true
--------------------------------
--Tabs and windows
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.95
config.tab_bar_at_bottom = true
config.inactive_pane_hsb = { saturation = 0.5, brightness = 0.5} 
config.adjust_window_size_when_changing_font_size = false
-----------------------------------
--FONTS AND COLORS--
config.bold_brightens_ansi_colors = true
--config.font = wezterm.font('JetBrainsMono Nerd Font', {weight='Bold'})
config.font = wezterm.font_with_fallback({{family="JetBrains Mono", weight="Bold"}, "Symbols Nerd Font Mono","Noto Color Emoji"})
config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())
config.font_size = 14.0
----------------------------------
--KeyBindings--
config.keys = {
 -- Clears the scrollback and viewport leaving the prompt line the new first line.
  {
    key = 'k',
    mods = 'CMD',
    action = act.ClearScrollback 'ScrollbackAndViewport',
  },
  {
    key = '-',
    mods = 'CTRL|ALT',
    action = act.SplitVertical{domain='CurrentPaneDomain'}
  },
  {
    key = '\\',
    mods = 'CTRL|ALT',
    action = act.SplitHorizontal{domain="CurrentPaneDomain"}
  },
  {
    key = 'UpArrow',
    mods = 'CTRL|ALT',
    action = act.ActivatePaneDirection 'Up'
  },
  {
    key = 'DownArrow',
    mods = 'CTRL|ALT',
    action = act.ActivatePaneDirection 'Down'
  },
  {
    key = 'RightArrow',
    mods = 'CTRL|ALT',
    action = act.ActivatePaneDirection 'Right'
  },
  {
    key = 'LeftArrow',
    mods = 'CTRL|ALT',
    action = act.ActivatePaneDirection 'Left'
  },
  {
    key = 'f',
    mods = 'CTRL|CMD',
    action = act.ToggleFullScreen
  }

}


return config
