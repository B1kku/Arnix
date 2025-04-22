local M = {}

M.lsp_setup = {
  settings = {
    Lua = {
      workspace = {
        library = {},
        hint = {
          enable = true
        },
        -- adjust these two values if your performance is not optimal
        maxPreload = 2000,
        preloadFileSize = 1000,
      },
      telemetry = { enable = false },
      diagnostics = {
        unusedLocalExclude = { "_*" }
      }
    }
  }
}

return M
