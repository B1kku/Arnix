return {
  {
    -- Git integration --
    "tpope/vim-fugitive"
  },
  {
    -- Commit history  --
    "junegunn/gv.vim"
    -- TODO: Deprecate and use telescope git plugin instead...
  },
  {
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
}
