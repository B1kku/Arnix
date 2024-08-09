local vfn = vim.fn

local function get_last_buffer()
  local last_buffer = vim.iter(vim.fn.getbufinfo({ bufloaded = 1, buflisted = 1 })):fold({ lastused = 0 },
    function(prev_buffer, buffer)
      if prev_buffer.lastused > buffer.lastused then
        return prev_buffer
      else
        return buffer
      end
    end)
  return (last_buffer.bufnr) and last_buffer or nil
end

local function get_bufpath(bufnr)
  return vfn.fnamemodify(vfn.bufname(bufnr), ':p')
end

local get_yazi_cmd = function()
  local last_buffer = get_last_buffer()
  local buf_path = last_buffer and get_bufpath(last_buffer.bufnr) or vfn.getcwd()
  return "yazi " .. "\"" .. buf_path .. "\""
end

return {
  on_create = function(terminal)
    terminal.cmd = get_yazi_cmd()
  end,
  cmd = get_yazi_cmd()
}
