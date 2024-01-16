local color = vim.g.colors_name
local bg1 = require("nightfox.palette." .. color).palette.bg1
local lualine_theme = require("lualine.themes." .. color)
lualine_theme.inactive.b.bg = bg1
return lualine_theme
