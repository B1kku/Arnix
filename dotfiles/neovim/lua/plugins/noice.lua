return {
  {
    -- Still don't know why, but mapping ":w<cr>" shows double saving message until using :Noice, "<cmd>w<cr>" does not.
    "folke/noice.nvim",
    enabled = true,
    dependencies = {
      { "MunifTanjim/nui.nvim" },
      { "folke/snacks.nvim" }
      -- { "rcarriga/nvim-notify" },
      -- { "hrsh7th/nvim-cmp" }
    },
    config = function()
      require("noice").setup({
        presets = {
          long_message_to_split = true
        },
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
          },
          progress = { enabled = true },
          signature = {
            enabled = false
          }
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
    --   require("notify").setup {
    --     -- Complains if not set
    --     background_colour = "#000000",
    --     max_width = vim.o.columns / 4,
    --     timeout = 800,
    --     -- stages = "slide", -- Too slow
    --     fps = 60
    --   }
    end
  }
}
