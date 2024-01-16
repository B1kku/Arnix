return {
  'echasnovski/mini.sessions',
  config = function()
    require('mini.sessions').setup {
      autoread = false,
      autowrite = true,
      force = {
        read = false,
        write = true,
        delete = true
      }
    }

    local sessions = require("extensions.sessions")

    local keys = {
      delete = "<C-d>",
      save = "<C-s>",
      rename = "<C-r>"
    }

    vim.keymap.set('n', '<leader>st', function() sessions.open(keys) end)
  end
}
