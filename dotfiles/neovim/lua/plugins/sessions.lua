return {
  'echasnovski/mini.sessions',
  config = function()
    local sessions_module = require("modules.sessions")
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
          write = sessions_module.pre_write,
          read = sessions_module.pre_read
        },
        post = {
          read = sessions_module.post_read
        }
      }
    }
    local keys = {
      delete = "<C-d>",
      save = "<C-s>",
      rename = "<C-r>"
    }
    -- Override minisessions' picker
    MiniSessions.select = function()
      require("modules.sessions.sessions_picker").open(keys)
    end
    -- TODO: Move to top
    vim.keymap.set('n', '<leader>st', MiniSessions.select)
  end
}
