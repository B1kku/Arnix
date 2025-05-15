local wezterm = require("wezterm")
local config = wezterm.config_builder()
local mux = wezterm.mux
local util = require("util")

local tbl_merge = util.tbl_merge
local merge_config = tbl_merge
local hex_to_rgba = util.hex_to_rgba

local opacity = 0.75
local color, _ = wezterm.color.load_base16_scheme(wezterm.config_dir .. "/colors/catpuccin-mocha.yml")
local base16 = util.base16(color)
local local_config = {
  colors = tbl_merge(color, {
    tab_bar = {
      background = hex_to_rgba(opacity, base16.base00)
    }
  }),
  front_end = "WebGpu",
  automatically_reload_config = true,
  hide_mouse_cursor_when_typing = false,
  window_background_opacity = opacity,
  hide_tab_bar_if_only_one_tab = true,
  font = wezterm.font 'FiraCode Nerd Font',
  use_dead_keys = false,
  window_padding = {
    left = 0,
    right = 0,
    top = 5,
    bottom = 0
  },
}
config = merge_config(config, local_config)
local background_color = hex_to_rgba(config.window_background_opacity, base16.base00)
-- local background_color = base16.base00
config.tab_max_width = 27
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.window_frame = {
  border_top_height = 5,
  border_top_color = background_color
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
  local background = base16.base01
  local foreground = base16.base05
  local edge_background = background_color

  if tab.is_active or hover then
    background = base16.base02
    foreground = base16.base06
  end
  local edge_foreground = background

  local title = tab_title(tab)

  -- ensure that the titles fit in the available space,
  -- and that we have room for the edges.
  local max = config.tab_max_width - 9
  if #title > max then
    title = wezterm.truncate_right(title, max) .. "…"
  end

  local first_segment = {
    { Background = { Color = edge_background   } },
    { Foreground = {Color = edge_foreground} },
    { Text = "" },

  }
  if tab.tab_index == 0 then
    first_segment = {
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = " " }
    }
  end

  return {
    first_segment[1],
    first_segment[2],
    first_segment[3],
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Attribute = { Intensity = tab.is_active and "Bold" or "Normal" } },
    { Text = " " .. (tab.tab_index + 1) .. " " .. title .. " " },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = "" },
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
