return {
  {
    -- Preference theme goes here --
    "EdenEast/nightfox.nvim",
    enabled = true,
    -- Must not load lazily and with highest priority, it's somewhat minor but otherwise Lazy might not get themed.
    priority = 1000,
    config = function()
      -- vim.cmd[[set pumblend=0]]
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
      vim.g.theme = "nightfox"
      vim.api.nvim_command("colorscheme nightfox") -- Set the colorscheme
    end
  },
  {
    "olimorris/onedarkpro.nvim",
    enabled = false,
    priority = 1000,
    config = function()
      require("onedarkpro").setup({
        options = {
          transparency = true
        }
      })
      vim.cmd("colorscheme vaporwave")
    end
  },
  {
    "rktjmp/lush.nvim",
    -- {dir = vim.fn.stdpath("config") .. "/lua/modules/colors.lua" }
  },
}
