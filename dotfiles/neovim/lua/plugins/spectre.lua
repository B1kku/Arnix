return {
  "nvim-pack/nvim-spectre",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
  },
  config = function()
    require("spectre").setup()
    vim.keymap.set("n", "<C-f>", '<cmd>lua require("spectre").toggle()<CR>')
  end


}
