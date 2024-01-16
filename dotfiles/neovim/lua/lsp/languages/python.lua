local M = {}

--Need to change pyvenv.cfg on venv to true for using system packages.
M.settings = {
  pylsp = {
    plugins = {
      pycodestyle = {
        -- ignore = { "E501" },
        maxLineLength = 100
      }
    }
  }
}

return M
