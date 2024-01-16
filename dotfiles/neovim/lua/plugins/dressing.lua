return {
  "stevearc/dressing.nvim",
  config = function()
    require("dressing").setup {
      input = {
        relative = "editor",
        title_pos = "center",
        border = vim.g.border,
        win_options = {
          winblend = 0
        }
      },
      select = {
        backend = {"telescope"}
      }
    }
  end
}
