return {
  {
    -- Signs for changes on git. --
    "lewis6991/gitsigns.nvim",
    event = "BufEnter",
    opts = {
      numhl = false,
      auto_attach = true,
      current_line_blame = true,
      signcolumn = true
    }
  },
  {
    "luukvbaal/statuscol.nvim",
    event = "BufEnter",
    config = function()
      local mod = require("modules.statuscolumn")
      local segments = mod.segments
      local function is_current_win(args)
        return args.win == args.actual_curwin
      end
      mod.setup_refresh_inactive_statuscolumns(50)
      require("statuscol").setup({
        bt_ignore = {
          "acwrite",
          "help",
          "nofile",
          "nowrite",
          "quickfix",
          "terminal",
          "prompt"
        },
        segments = {
          {
            text = {
              segments.num_column,
            },
            condition = {
              is_current_win
            }
          },
          {
            text = {
              segments.info_column
            },
            sign = {
              namespace = { "^nvim%.vim%.lsp%.[^%.]+%.%d+%.diagnostic%.signs$" },
              foldclosed = true,
            },
            condition = {
              is_current_win
            }
          },
          {
            text = {
              segments.separator_column
            },
            sign = {
              namespace = { "^gitsigns_signs_" },
              foldclosed = true,
              auto = true
            },
            condition = {
              is_current_win
            }
          },
        }
      })
    end
  }
}
