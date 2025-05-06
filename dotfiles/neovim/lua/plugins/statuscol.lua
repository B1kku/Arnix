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
      local function getnum(args)
        if (args.virtnum ~= 0) then return "┇" .. "%=" end
        if (args.relnum == 0) then
          return "%=" .. tostring(args.lnum)
        end
        return tostring(args.relnum) .. "%="
      end
      local util = require("util")

      -- No need to cleanup timer, this will live for the entirety of the session
      local refresh, _timer = util.debounce_trailing(function(to_refresh_wins)
        local count = #to_refresh_wins
        for i = 1, count do
          local win = to_refresh_wins[i]
          if (vim.api.nvim_win_is_valid(win)) then
            vim.api.nvim__redraw({ win = win, statuscolumn = true })
          end
          to_refresh_wins[i] = nil
        end
      end, 100, false)
      local to_refresh_wins = {}
      local current_win = vim.api.nvim_get_current_win()
      vim.api.nvim_create_autocmd("WinEnter", {
        callback = function()
          table.insert(to_refresh_wins, current_win)
          current_win = vim.api.nvim_get_current_win()
          refresh(to_refresh_wins)
        end
      })

      local function is_current_win(args) -- function used on condition
        return args.win == current_win
      end


      local function get_signs(args, segment)
        local ss = segment.sign
        local wss = ss.wins[args.win]
        local sss = wss.signs[args.lnum]
        if not sss then return false end
        return sss
      end

      local function git_signs(args, segment)
        if (args.virtnum ~= 0) then
          return "┇"
        end
        local line_signs = get_signs(args, segment)
        if not line_signs then
          return "│"
        end
        local sign = line_signs[1]
        return "%#" .. sign.sign_hl_group .. "#" .. string.sub(sign.sign_text, 1, -2) .. "%*"
      end
      require("statuscol").setup({
        segments = {
          {
            text = {
              getnum,
              " "
            },
            condition = {
              is_current_win,
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
