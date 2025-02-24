return {
  {
    "nvim-pack/nvim-spectre",
    config = function()
      require("spectre").setup()
      vim.keymap.set("n", "<C-f>", '<cmd>lua require("spectre").toggle()<CR>')
    end
  },
  { "nvim-lua/plenary.nvim", lazy = true },
}
