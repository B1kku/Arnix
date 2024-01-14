return {
  {
    -- Still don't know why, but mapping ":w<cr>" shows double saving message until using :Noice, "<cmd>w<cr>" does not.
    "folke/noice.nvim",
    dependencies = {
      { "MunifTanjim/nui.nvim" },
      { "rcarriga/nvim-notify" }
    },
    config = function()
      require("notify").setup {
        background_colour = "#000000"
      }
      require("noice").setup({
        presets = {
          lsp_doc_border = true
        },
        lsp = {
          progress = { enabled = false }
        }
      })
    end
  }
}
