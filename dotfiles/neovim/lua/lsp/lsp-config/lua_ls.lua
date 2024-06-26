local M = {}

M.settings = {
  Lua = {
    workspace = {
      library = {},

      -- adjust these two values if your performance is not optimal
      maxPreload = 2000,
      preloadFileSize = 1000,
    },
    telemetry = { enable = false },
  }
}

return M
