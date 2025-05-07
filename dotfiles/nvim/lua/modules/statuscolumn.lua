local M = {}

-- Setups a debounce to refresh the statuscolumn of windows the user left
-- This is due to a bug? where statuscolumn won't be hidden if nothing
-- is shown without a refresh.
---@param delay_ms integer
function M.setup_refresh_inactive_statuscolumns(delay_ms)
  local util = require("util")
  local refresh, timer = util.debounce_trailing(function(to_refresh_wins)
    local count = #to_refresh_wins
    for i = 1, count do
      local win = to_refresh_wins[i]
      if (vim.api.nvim_win_is_valid(win)) then
        vim.api.nvim__redraw({ win = win, statuscolumn = true })
      end
      to_refresh_wins[i] = nil
    end
  end, delay_ms, false)
  vim.api.nvim_create_autocmd("VimLeave", {
    callback = function()
      timer:close()
    end
  })
  -- Keep track of windows we've switched from, then launch a debounce
  -- to refresh these windows' statuscolumn, it's better than calling
  -- from every single line of each statuscolumn
  local to_refresh_wins = {}
  local current_win = vim.api.nvim_get_current_win()
  vim.api.nvim_create_autocmd("WinEnter", {
    callback = function()
      table.insert(to_refresh_wins, current_win)
      current_win = vim.api.nvim_get_current_win()
      refresh(to_refresh_wins)
    end
  })
end
-- Given args and the segment, returns the signs
-- statuscolumn matched for this given line.
---@param args any
---@param segment any
---@return vim.api.keyset.extmark_details[]?
function M.get_signs(args, segment)
  local ss = segment.sign
  local wss = ss.wins[args.win]

  local sss = wss.signs[args.lnum]
  if not sss then return nil end
  return sss
end

return M
