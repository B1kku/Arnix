local vfn = vim.fn

local function get_bufpath(bufnr)
  return vfn.fnamemodify(vfn.bufname(bufnr), ':p')
end
local get_yazi_cmd = function()
  local function check_buffer(bufnr)
    local buf_id = vfn.bufnr(bufnr)
    if buf_id == -1 or not vfn.bufloaded(buf_id) then
      return false
    end
    return true
  end

  local buf_path
  if check_buffer("#") then
    buf_path = get_bufpath("#")
  elseif check_buffer("%") then
    buf_path = get_bufpath("%")
  else
    buf_path = vfn.getcwd()
  end
  return "yazi " .. "\"" .. buf_path .. "\""
end

return {
  on_create = function(terminal)
    terminal.cmd = get_yazi_cmd()
  end,
  cmd = get_yazi_cmd()
}
