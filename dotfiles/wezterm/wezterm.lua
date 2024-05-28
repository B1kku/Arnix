local wezterm = require("wezterm")

local config = wezterm.config_builder()
local mux = wezterm.mux
config = {
  -- color_scheme = 'AdventureTime',
  automatically_reload_config = true,
  window_background_opacity = 0.75,
  hide_tab_bar_if_only_one_tab = true,
  window_decorations = "NONE",
  font = wezterm.font 'FiraCode Nerd Font',
  use_dead_keys = false,
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0
  }
}

wezterm.on('gui-attached', function(domain)
  -- maximize all displayed windows on startup
  local workspace = mux.get_active_workspace()
  for _, window in ipairs(mux.all_windows()) do
    if window:get_workspace() == workspace then
      window:gui_window():maximize()
    end
  end
end)
return config
