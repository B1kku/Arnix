return {
  {
    "nvim-pack/nvim-spectre",
    keys = {
      {"<C-f>", "<cmd>lua require('spectre').toggle()<CR>"}
    },
    opts = {}
  },
  { "nvim-lua/plenary.nvim", lazy = true },
}
