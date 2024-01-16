return {
  "folke/twilight.nvim",
  config = function()
    require("twilight").setup {
      dimming = {
        alpha = 0.25,
      },
      -- context = 20,
    }
    -- vim.cmd("Twilight")

  end
}
