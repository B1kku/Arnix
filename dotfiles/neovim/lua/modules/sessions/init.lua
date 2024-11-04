local module_path = "modules.sessions."
local sessions_toggleterm = require(module_path .. "sessions_toggleterm")
local sessions_overseer = require(module_path .. "sessions_overseer")
local M = {}

M.pre_write = function()
  sessions_overseer.pre_write()
end
M.pre_read = function()
  sessions_overseer.pre_read()
  vim.cmd("LspStop")
end
M.post_read = function()
  sessions_toggleterm.post_read()
  sessions_overseer.post_read()
end

return M
