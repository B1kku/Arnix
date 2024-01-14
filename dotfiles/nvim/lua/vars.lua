--[[ vars.lua ]]
--
local single = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }
local rounded = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
local double = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" }
local g = vim.g
--  Theme  --
g.t_co = 256
g.background = "dark"

g.borderchars = rounded
g.border = "rounded"

g.theme = "nightfox" -- Global variable for other plugins to use if needed.
