local M = {}

---@param args string[]
local function parse(args)
  local parsed_args = {
    lnum = nil,
    files = {},
    unknown = {}
  }
  local files_switch = false
  for _, value in ipairs(args) do
    if (not files_switch) then
      -- Anything after -- should be treated as a file name
      if (value == "--") then
        files_switch = true
        goto continue
      end
      -- Check if it's a lnum +1234
      local num = value:match("^%+(%d+)$")
      if (num) then
        parsed_args.lnum = tonumber(num)
        goto continue
      end
      -- For now - options or +cmd are counted as unsupported.
      local arg_flag = value:match("^[+-].?")
      if (arg_flag) then
        table.insert(parsed_args.unknown, arg_flag)
        goto continue
      end
    end
    table.insert(parsed_args.files, value)
    ::continue::
  end
  return parsed_args
end


--- Receive arguments used on the remote script.
---@param pid integer process id from the caller script
---@param args string[] cli args passed to the script thinking it was nvim
function M.receive(pid, args)
  local parsed_args = parse(args)
  if (#parsed_args.unknown > 0) then
    local warning = "Failed to parse the following args:"
    for _, value in ipairs(parsed_args.unknown) do
      warning = warning .. "\n\t- " .. value
    end
    vim.notify(warning, vim.log.levels.WARN, { title = "Neovim-wrapper" })
  end

  -- Usually this script must've been invoked from a terminal
  -- It's usually when it's a terminal we want to hide it.
  local bufnr = vim.api.nvim_get_current_buf()
  local buftype = vim.api.nvim_get_option_value("buftype", { buf = bufnr })
  if (buftype == "terminal") then
    vim.api.nvim_win_hide(0)
  end

  for i = #parsed_args.files, 1, -1 do
    vim.cmd.edit(parsed_args.files[i])
  end
  if (parsed_args.lnum) then
    vim.api.nvim_win_set_cursor(0, { parsed_args.lnum, 0 })
  end
  os.execute("kill " .. pid)
end

return M
