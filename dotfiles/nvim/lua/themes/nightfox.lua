return {
  {
    -- Preference theme goes here --
    "EdenEast/nightfox.nvim",
    enabled = true,
    -- Must not load lazily and with highest priority, it's somewhat minor but otherwise Lazy might not get themed.
    priority = 1000,
    config = function()
      local palette = "nightfox"

      require("nightfox").setup {
        options = {
          transparent = true,
          terminal_colors = true,
          -- dim_inactive = true
        },
        groups = {
          all = {
            -- More transparency, I feel this should be by default
            NormalFloat = { bg = "NONE", },
            -- Cmp transparency
            Pmenu = { bg = "NONE" },
          },
        },
      }
      vim.api.nvim_command("colorscheme " .. palette) -- Set the colorscheme

      local palette_colors = require("nightfox.palette").load(palette)
      local bg_color = palette_colors.bg0
      -- User defined lualine theme overrides
      -- in this case, restore bgcolor
      local lualine_overrides = {
        inactive = {
          a = {
            bg = bg_color
          },
          b = {
            bg = bg_color
          },
          c = {
            bg = bg_color
          }
        },
        normal = {
          c = {
            bg = bg_color
          }
        }
      }
      -- Merge user lualine theme opts into default lualine theme
      -- then modify the package path to return the new theme instead.
      local nightfox_lualine = "lualine.themes." .. palette
      local lualine_theme = require(nightfox_lualine)
      lualine_theme = vim.tbl_deep_extend("force", lualine_theme, lualine_overrides)
      package.loaded[nightfox_lualine] = lualine_theme
    end
  }
}
