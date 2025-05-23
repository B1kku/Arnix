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
      local builtin = require("statuscol.builtin")
      local C = require("statuscol.ffidef").C
      local aligner = "%="
      local reset_hl = "%*"

      local virtnum_char = "┇"
      local padding_char = " "

      local fillchars = vim.opt.fillchars:get()
      local function num_column(args)
        if (args.virtnum ~= 0) then return virtnum_char .. aligner .. padding_char end
        if (args.relnum == 0) then
          return "%=" .. tostring(args.lnum) .. padding_char
        end
        return tostring(args.relnum) .. aligner .. padding_char
      end
      local function info_column(args, segment)
        if (args.virtnum ~= 0) then return " " .. padding_char end
        local signs = mod.get_signs(args, segment)
        if signs then
          local sign = signs[1]
          return "%#" .. sign.sign_hl_group .. "#" .. string.sub(sign.sign_text, 1, -2) .. padding_char .. reset_hl
        end
        local foldinfo = C.fold_info(args.wp, args.lnum)
        local closed = foldinfo.lines > 0
        if closed then
          return "%#CursorLineFold#" .. fillchars.foldclose .. padding_char .. reset_hl
        end
        if foldinfo.start == args.lnum then
          return "%#CursorLineFold#" .. fillchars.foldopen .. padding_char .. reset_hl
        end
        return " " .. padding_char
      end
      local function separator_column(args, segment)
        if (args.virtnum ~= 0) then
          return virtnum_char
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
              num_column,
            },
            condition = {
              is_current_win
            }
          },
          {
            text = {
              info_column
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
              separator_column
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
