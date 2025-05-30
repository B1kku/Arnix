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

local curfold = {
  start = 0,
  level = 0,
  buf = 0,
  window = 0
}
---Start tracking which fold is under the cursor
---This is required so the segment for folds knows
---which fold the cursor is under, so it highlights it.
---@param delay_ms number  Delay in ms after which to update and throttle the fold position.
function M.setup_track_cursor_fold(delay_ms)
  local util = require("util")
  local ffi = require("ffi")
  local error = nil
  local prev_lnum = 0
  local wp = ffi.C.find_window_by_handle(0, error)
  local function refresh_curfold()
    local curbuf = vim.api.nvim_get_current_buf()
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = curbuf })
    local curwindow = vim.api.nvim_get_current_win()
    -- Wrong buffer, don't even bother, wipe other settings too
    if buftype ~= "" then
      curfold = {
        start = 0,
        level = 0,
        buf = 0,
        window = 0
      }
      prev_lnum = 0
      return
    end
    -- Window changed, refresh wp
    if (curfold.buf ~= curbuf) then
      wp = ffi.C.find_window_by_handle(curwindow, error)
      curfold.window = curwindow
      curfold.buf = curbuf
    end
    -- Something went wrong, o.O
    if (wp == nil) then
      curfold = {
        start = 0,
        level = 0,
        buf = 0,
        window = 0
      }
      prev_lnum = 0
      return
    end
    local curline = vim.api.nvim_win_get_cursor(curwindow)[1]

    if prev_lnum == curline then
      return
    end
    prev_lnum = curline
    local foldinfo = ffi.C.fold_info(wp, curline)
    curfold.level = foldinfo.level
    curfold.start = foldinfo.start
  end
  local refresh_curfold_throttled, _timer = util.throttle_trailing(refresh_curfold, delay_ms, false)
  -- Refresh the current fold info on cursor moved with a throttle
  vim.api.nvim_create_autocmd("BufEnter", {
    callback = refresh_curfold_throttled
  })
  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    callback = refresh_curfold_throttled
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

local C = require("statuscol.ffidef").C
local aligner = "%="
local reset_hl = "%*"

local virtnum_char = "┇"
local padding_char = " "

local fillchars = vim.opt.fillchars:get()

local segments = {}
M.segments = segments

function segments.num_column(args)
  local linehl = "LineNr"
  local curlinehl = "CursorLineNr"
  if (args.virtnum ~= 0) then return "%#" .. linehl .. "#" .. virtnum_char .. aligner .. padding_char .. reset_hl end
  if (args.relnum == 0) then
    return "%=" .. "%#" .. curlinehl .. "#" .. tostring(args.lnum) .. padding_char .. reset_hl
  end
  return tostring(args.relnum) .. aligner .. padding_char .. reset_hl
end

function segments.info_column(args, segment)
  if (args.virtnum ~= 0) then return " " .. padding_char end
  local signs = M.get_signs(args, segment)
  if signs then
    local sign = signs[1]
    return "%#" .. sign.sign_hl_group .. "#" .. string.sub(sign.sign_text, 1, -2) .. padding_char .. reset_hl
  end
  local foldinfo = C.fold_info(args.wp, args.lnum)
  local foldtext = padding_char .. reset_hl
  local closed = foldinfo.lines > 0
  local foldhl = "%#CursorLineFold#"
  if (curfold.buf == args.buf and curfold.level == foldinfo.level and args.lnum == curfold.start) then
    foldhl = "%#CursorLineNr#"
  end
  if closed then
    return foldhl .. fillchars.foldclose .. foldtext
  end
  if foldinfo.start == args.lnum then
    foldtext = fillchars.foldopen .. foldtext
    -- This is the current fold zc will close, highlight it accordingly.
    if (curfold.buf == args.buf and curfold.level == foldinfo.level and args.lnum == curfold.start) then
      return foldhl .. foldtext
    end
    return foldhl .. foldtext
  end
  return " " .. padding_char
end

function segments.separator_column(args, segment)
  if (args.virtnum ~= 0) then
    return virtnum_char
  end
  local line_signs = M.get_signs(args, segment)
  if not line_signs then
    return "│"
  end
  local sign = line_signs[1]
  return "%#" .. sign.sign_hl_group .. "#" .. string.sub(sign.sign_text, 1, -2) .. "%*"
end

return M
