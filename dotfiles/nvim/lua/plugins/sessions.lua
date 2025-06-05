local session_select = function ()
  require("mini.sessions").select()
end
return {
  -- Picker module
  LazyDep("nvim-telescope/telescope.nvim"),
  {
  'echasnovski/mini.sessions',
  keys = {
    { "<leader>st", session_select, "n", silent = true, desc = "Session picker" }
  },
  config = function()
    local minisessions = require("mini.sessions")
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
    -- Override minisessions' picker
    local custom_picker = require("modules.sessions.sessions_picker")
    custom_picker.setup()
    minisessions.select = custom_picker.open
    session_select = minisessions.select
  end
  }
}
