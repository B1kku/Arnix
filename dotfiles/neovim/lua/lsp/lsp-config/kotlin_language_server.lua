local M = {}
local fn = vim.fn
M.lsp_setup = {
  init_options = {
    storagePath = fn.resolve(fn.stdpath("cache") .. "/kotlin_language_server")
  }
}

return M
