return {
  'stevearc/overseer.nvim',
  config = function()
    vim.o.exrc = true

    local win_opts = {
      winblend = 0,
    }
    local overseer = require('overseer')
    overseer.setup({
      bundles = {
        autostart_on_load = false
      },
      templates = { "builtin", "java.maven", "java.test", "wrapper" },
      task_list = {
        direction = "bottom"
      },
      form = {
        win_opts = win_opts
      },
      confirm = {
        win_opts = win_opts
      },
      task_win = {
        win_opts = win_opts
      }
    })
  end,
}
