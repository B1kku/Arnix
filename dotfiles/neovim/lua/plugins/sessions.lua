return {
  'echasnovski/mini.sessions',
  config = function()
    local overseer_sessions = require("extensions.overseer-sessions")
    require('mini.sessions').setup {
      autoread = false,
      autowrite = true,
      force = {
        read = false,
        write = true,
        delete = true
      },
      hooks = {
        pre = {
          write = overseer_sessions.pre_write,
          read = overseer_sessions.pre_read
        },
        post = {
          read = overseer_sessions.post_read
        }
      }
    }

    local sessions = require("extensions.sessions")
    local keys = {
      delete = "<C-d>",
      save = "<C-s>",
      rename = "<C-r>"
    }
    -- Override minisessions' picker
    MiniSessions.select = function()
      sessions.open(keys)
    end
    vim.keymap.set('n', '<leader>st', MiniSessions.select)
  end
}
