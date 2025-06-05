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

---@module "lazy"

--- This actually does relatively nothing, it's just a way for me to mark
--- a plugin as a dependency so it's not confused with a normal plugin spec.
--- The reason for this existing is that the dependencies table on a lazyplugspec
--- actually instantly loads said plugin before the parent is loaded, so far,
--- haven't found a single plugin that requires this. Declaring a dependency as
--- another plugin and setting it to lazy only loads it when the parent actually requires it.
---@param plugin string
---@param opts LazySpec?
---@return LazySpec
LazyDep = function(plugin, opts)
  if not opts then
    opts = {}
  end
  return vim.tbl_extend("force", {plugin, lazy = true}, opts)
end

I = function(arg)
  vim.notify(vim.inspect(arg), 2)
end
D = function(arg)
  vim.notify_once(vim.inspect(arg), 2)
end
