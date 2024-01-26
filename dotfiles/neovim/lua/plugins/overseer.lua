return {
  'stevearc/overseer.nvim',
  opts = {},
  config = function ()
    vim.o.exrc = true
    require('overseer').setup()
  end
}
