return {
  -- Preference theme goes here --
  "EdenEast/nightfox.nvim",
  -- Must not load lazily and with highest priority, it's somewhat minor but otherwise Lazy might not get themed.
  priority = 1000,
  config = function()
    -- vim.cmd[[set pumblend=0]]
    require("nightfox").setup {
      options = {
        transparent = true,
        terminal_colors = false,
        -- dim_inactive = true
      },
      groups = {
        all = {
          -- More transparency, I feel this should be by default
          NormalFloat = { fg = "fg1", bg = "NONE", },
          -- Cmp transparency
          PMenu = { bg = "NONE" },
        },
      },
    }
    vim.g.theme = "nightfox"
    vim.api.nvim_command("colorscheme duskfox") -- Set the colorscheme
  end
}
