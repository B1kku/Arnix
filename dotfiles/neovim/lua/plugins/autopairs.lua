return {
  -- Auto close brackets --
  "windwp/nvim-autopairs",
  enabled = true,
  config = function()
    require("nvim-autopairs").setup {
      check_ts = true,
      ts_config = {
        -- lua = { "string", "source" },
        -- java = false,
      },
      disable_filetype = {},
    }
  end
}
