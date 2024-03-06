return {
  'stevearc/conform.nvim',
  keys = {
    { "<leader>sf", [[<cmd>lua require("conform").format({lsp_fallback = true, async = true})<CR>]], desc = "Format file" }
  },
  config = function()
    local conform = require("conform")
    conform.formatters["google-java-format"] = {
      prepend_args = {"-a"}
    }
    conform.setup({
      formatters_by_ft = {
        java = { "google-java-format" }
      }
    })
  end
}
