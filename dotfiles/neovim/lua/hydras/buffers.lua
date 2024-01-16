local hydra_ok, Hydra = pcall(require, "hydra")
if not hydra_ok then
  vim.notify("Hydra wasn't found, can't register.")
  return
end
local lualine = require("lualine")
local cmd = require('hydra.keymap-util').cmd

local hint = [[
  Patata
]]

Hydra({
  name = "Buffers",
  hint = hint,
  config = {
      on_key = lualine.refresh
  },
  body = "<leader>b",
  heads = {
    { "<left>", cmd "bprev" },
    { "<right>", cmd "bnext"},
    { "d", cmd "bdel"}
  }
})
