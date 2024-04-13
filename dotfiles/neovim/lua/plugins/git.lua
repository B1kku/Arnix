return {
  -- Signs for changes on git. --
  "lewis6991/gitsigns.nvim",
  event = "BufEnter",
  config = function()
    require("gitsigns").setup {
      numhl = true,
      current_line_blame = true
      -- signcolumn = false
    }
  end
}
