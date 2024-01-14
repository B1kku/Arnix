return {
  -- Bar at the bottom with info --
  "nvim-lualine/lualine.nvim",
  config = function()
    local components = require("extensions.lualine")
    local active_register = components.active_register
    local center_component = components.center_component
    local lsp_name = components.lsp_name
    local lsp_progress = components.lsp_progress

    require("lualine").setup {
      options = {
        theme = require("themes.lualine.nightfox"),
      },
      -- Add buffers to the left bottom and remove filename from center as it's already on buffers.
      sections = {
        lualine_a = {
          active_register,
          { "datetime", style = " %H:%M" }, -- Note: barely using it, might delete.
          "branch"
        },
        lualine_b = {
          {
            "buffers",
            hide_filename_extension = true,
            symbols = { alternate_file = "" },
            max_length = vim.o.columns / 3
          }
        },
        lualine_c = { center_component, lsp_progress, "diagnostics" },
        -- lualine_x = { "diagnostics", center_component }
        lualine_x = { "" },
        lualine_y = { "diff", lsp_name }
      }
    }
  end
}
