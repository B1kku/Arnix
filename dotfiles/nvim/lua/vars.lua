--[[ vars.lua ]]
--
-- local single = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }
local rounded = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
-- local double = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" }
local g = vim.g
--  Theme  --
g.t_co = 256
g.background = "dark"
-- NOTE: Should keep an eye on this, neovim finally has an standard
-- vim.o.winborder
g.borderchars = rounded
g.border = "rounded"

g.theme = "nightfox" -- Global variable for other plugins to use if needed.

I = function(arg)
  vim.print(vim.inspect(arg))
end
