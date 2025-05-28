local M = {}
--- Strip whitespace on the left of the string
---@param s string
---@return string
function M.rstrip(s)
  s, _ = s:gsub("%s+$", "")
  return s
end

--- Strip whitespace on the left of the string
---@param s string
---@return string
function M.lstrip(s)
  s, _ = s:gsub("^%s+", "")
  return s
end

--- Strip whitespace at the beginning and end of a string
---@param s string
---@return string
function M.strip(s)
  s, _ = s:gsub("^%s*(.-)%s*$", "%1")
  return s
end

--- Returns whether a path is a subpath of another
---@param child string
---@param root string
---@return boolean
function M.is_subdir(child, root)
  return child:sub(1, #root) == root
end

-- Source https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/debounce.lua

--- Runs the code after it stops being called for ms
--- Debounces a function on the trailing edge. Automatically `schedule_wrap()`s.
---@param fn fun(...) Function to debounce
---@param ms number Timeout in ms
---@param first? boolean Whether to use the arguments of the first call to `fn` within the timeframe.
--- Default: Use arguments of the last call.
---@return fun(...) wrapped_fn Debounced function
---@return uv.uv_timer_t timer Remember to call `timer.close()` at the end or you will leak memory!
function M.debounce_trailing(fn, ms, first)
  local timer = vim.uv.new_timer()
  ---@cast timer -nil
  local wrapped_fn
  if not first then
    function wrapped_fn(...)
      local argv = { ... }
      local argc = select("#", ...)
      timer:start(ms, 0, function()
        pcall(vim.schedule_wrap(fn), unpack(argv, 1, argc))
      end)
    end
  else
    local argv, argc
    function wrapped_fn(...)
      argv = argv or { ... }
      argc = argc or select("#", ...)

      timer:start(ms, 0, function()
        pcall(vim.schedule_wrap(fn), unpack(argv, 1, argc))
      end)
    end
  end
  return wrapped_fn, timer
end

--- Debounces a function on the leading edge. Automatically `schedule_wrap()`s.
--- Runs the code, doesn't repeat until it stops being called for ms
---@param fn fun(...) Function to debounce
---@param ms number Timeout in ms
---@return fun(...) wrapped_fn Debounced function
---@return uv.uv_timer_t timer Remember to call `timer.close()` at the end or you will leak memory!
function M.debounce_leading(fn, ms)
  local timer = vim.uv.new_timer()
  ---@cast timer -nil
  local running = false

  local function wrapped_fn(...)
    timer:start(ms, 0, function()
      running = false
    end)

    if not running then
      running = true
      pcall(vim.schedule_wrap(fn), select(1, ...))
    end
  end
  return wrapped_fn, timer
end

--- Throttles a function on the leading edge. Automatically `schedule_wrap()`s.
--- Runs the code, doesn't repeat until ms delay.
---@param fn fun(...) Function to throttle
---@param ms number Timeout in ms
---@return fun(...) wrapped_fn Throttled function
---@return uv.uv_timer_t timer Remember to call `timer.close()` at the end or you will leak memory!
function M.throttle_leading(fn, ms)
  local timer = vim.uv.new_timer()
  ---@cast timer -nil
  local running = false

  local function wrapped_fn(...)
    if not running then
      timer:start(ms, 0, function()
        running = false
      end)
      running = true
      pcall(vim.schedule_wrap(fn), select(1, ...))
    end
  end
  return wrapped_fn, timer
end

--- Throttles a function on the trailing edge. Automatically `schedule_wrap()`s.
--- Runs after ms delay, doesn't repeat until ms delay.
---@param fn fun(...) Function to throttle
---@param ms number Timeout in ms
---@param last? boolean Whether to use the arguments of the last call to `fn` within the timeframe.
--- Default: Use arguments of the first call.
---@return fun(...) wrapped_fn Throttled function
---@return uv.uv_timer_t timer Remember to call `timer.close()` at the end or you will leak memory!
function M.throttle_trailing(fn, ms, last)
  local timer = vim.loop.new_timer()
  ---@cast timer -nil
  local running = false

  local wrapped_fn
  if not last then
    function wrapped_fn(...)
      if not running then
        local argv = { ... }
        local argc = select("#", ...)

        timer:start(ms, 0, function()
          running = false
          pcall(vim.schedule_wrap(fn), unpack(argv, 1, argc))
        end)
        running = true
      end
    end
  else
    local argv, argc
    function wrapped_fn(...)
      argv = { ... }
      argc = select("#", ...)

      if not running then
        timer:start(ms, 0, function()
          running = false
          pcall(vim.schedule_wrap(fn), unpack(argv, 1, argc))
        end)
        running = true
      end
    end
  end
  return wrapped_fn, timer
end

return M
