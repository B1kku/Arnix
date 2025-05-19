return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@module "snacks"
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    explorer = { enabled = true },
    indent = {
      enabled = true,
      indent = {
        only_current = true
      },
      scope = {
        underline = true
      },
      animate = {
        style = "down",
        easing = "outSine"
      }
    },
    scope = { enabled = true },
    input = { enabled = true },
    picker = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scroll = {
      enabled = true,
      filter = function(buf)
        return vim.g.snacks_scroll ~= false
            and vim.b[buf].snacks_scroll ~= false
            and vim.bo[buf].buftype == ""
      end
    },
    statuscolumn = {
      enabled = true,
      right = {},
      left = { "git", "fold", "sign" }
    },
    words = { enabled = true },
  },
}
