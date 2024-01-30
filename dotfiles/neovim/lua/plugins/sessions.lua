return {
  'echasnovski/mini.sessions',
  config = function()
    -- Hehe, there's an option for this...
    -- Leaving this here in case it's useful someday
    -- Remove terminals from sessions.
    -- local api = vim.api
    -- local remove_terminal_bufs = function()
    --   for _, buf in ipairs(api.nvim_list_bufs()) do
    --     local buftype = api.nvim_buf_get_option(buf, 'buftype')
    --     if buftype == 'terminal' then
    --       api.nvim_buf_delete(buf, { force = true })
    --     end
    --   end
    -- end
    -- local post_read = function()
    --   remove_terminal_bufs()
    -- end 

    require('mini.sessions').setup {
      autoread = false,
      autowrite = true,
      force = {
        read = false,
        write = true,
        delete = true
      },
      -- hooks = {
      --   post = { read = post_read }
      -- }
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
