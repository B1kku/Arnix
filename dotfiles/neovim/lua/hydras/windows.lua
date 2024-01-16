local hydra_ok, Hydra = pcall(require, "hydra")
if not hydra_ok then
  vim.notify("Hydra wasn't found, can't register.")
  return
end
local cmd = require('hydra.keymap-util').cmd

local hint = [[
  FIXME
]]

Hydra({
  name = "Buffers",
  hint = hint,
  body = "<leader>b",
  heads = {

  }
})
