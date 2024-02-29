return {
  'stevearc/conform.nvim',
  keys = {
    { "<leader>sf", [[<cmd>lua require("conform").format({lsp_fallback = true, async = true})<CR>]], desc = "Format file" }
  },
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        java = { "astyle" }
      }
    })
  end
}
