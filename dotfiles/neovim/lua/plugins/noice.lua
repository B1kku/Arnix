return {
  {
    -- Still don't know why, but mapping ":w<cr>" shows double saving message until using :Noice, "<cmd>w<cr>" does not.
    "folke/noice.nvim",
    dependencies = {
      { "MunifTanjim/nui.nvim" },
      { "rcarriga/nvim-notify" },
      { "hrsh7th/nvim-cmp" }
    },
    config = function()
      require("noice").setup({
        presets = {
          lsp_doc_border = true,
          long_message_to_split = true
        },
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
          },
          progress = { enabled = true }
        },
        routes = {
          {
            filter = {
              event = "msg_show",
              kind = "",
              find = "written",
            },
            opts = { skip = true },
          },
        }
      })

      require("notify").setup {
        -- Complains if not set
        background_colour = "#000000",
        max_width = vim.o.columns / 4,
        timeout = 800,
        -- stages = "slide", -- Too slow
        fps = 60
      }
    end
  }
}
