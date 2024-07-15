local wezterm = require("wezterm")

local config = wezterm.config_builder()
local mux = wezterm.mux
config = {
  -- color_scheme = 'AdventureTime',
  automatically_reload_config = true,
  hide_mouse_cursor_when_typing = false,
  window_background_opacity = 0.75,
  hide_tab_bar_if_only_one_tab = true,
  window_decorations = "RESIZE", -- https://github.com/wez/wezterm/issues/4569
  font = wezterm.font 'FiraCode Nerd Font',
  use_dead_keys = false,
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0
  }
}
config.tab_max_width = 32
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.colors = {
  tab_bar = {
    background = "rgba(0,0,0," .. config.window_background_opacity .. ")"
  }
}

-- Credit to https://github.com/MagicDuck
local function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, conf, hover, max_width)
  local background = "#435ac6"
  local foreground = "#b5b3b0"
  local edge_background = config.colors.tab_bar.background

  if tab.is_active or hover then
    background = "#5b9fff"
    foreground = "#F0F2F5"
  end
  local edge_foreground = background

  local title = tab_title(tab)

  -- ensure that the titles fit in the available space,
  -- and that we have room for the edges.
  local max = config.tab_max_width - 9
  if #title > max then
    title = wezterm.truncate_right(title, max) .. "…"
  end

  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = " " },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Attribute = { Intensity = tab.is_active and "Bold" or "Normal" } },
    { Text = " " .. (tab.tab_index + 1) .. ": " .. title .. " " },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = "" },
  }
end)

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
