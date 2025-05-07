local M = {}
-- This is pretty trivial, main reason for it existing is so I can define all keymaps
-- on the config part and keep it cleaner.
M.set_terminal_keymaps = function(terminal, keys, key_opts)
  local bufkeymap = vim.api.nvim_buf_set_keymap
  local bufnr = terminal.bufnr
  for _, keydef in pairs(keys) do
    local opts = keydef[4] and vim.tbl_extend("force", key_opts, keydef[4]) or {}
    bufkeymap(bufnr, keydef[1], keydef[2], keydef[3], opts)
  end
end

-- Every terminal cmd will get NVIM_WRAPPER added to it as the $EDITOR
-- This makes it so opening a neovim-related file on any terminal uses the already
-- existing neovim instance, and doesn't open a new one.
M.create_terminals = function(Terminal, terminal_list, default_terminal_opts)
  local terminals = {}
  for _, value in ipairs(terminal_list) do
    local terminal_config = require("terminals." .. value)
    terminals[value] = Terminal:new(
      vim.tbl_extend("force", default_terminal_opts, terminal_config)
    )
  end
  return terminals
end
return M
