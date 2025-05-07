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
      local function getnum(args)
        local padding = " "
        if (args.virtnum ~= 0) then return "┇" .. "%=" .. padding end
        if (args.relnum == 0) then
          return "%=" .. tostring(args.lnum) .. padding
        end
        return tostring(args.relnum) .. "%=" .. padding
      end
      local function git_signs(args, segment)
        if (args.virtnum ~= 0) then
          return "┇"
        end
        local line_signs = mod.get_signs(args, segment)
        if not line_signs then
          return "│"
        end
        local sign = line_signs[1]
        return "%#" .. sign.sign_hl_group .. "#" .. string.sub(sign.sign_text, 1, -2) .. "%*"
      end
      local function is_current_win(args)
        return args.win == args.actual_curwin
      end
      mod.setup_refresh_inactive_statuscolumns(50)
      require("statuscol").setup({
        segments = {
          {
            text = {
              getnum,
            },
            condition = {
              is_current_win
            }
          },
          {
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
              git_signs
            },
            sign = {
              namespace = { "^gitsigns_signs_" },
              name = { "DummySign" },
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
