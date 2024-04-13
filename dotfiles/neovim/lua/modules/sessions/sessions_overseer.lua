local M = {}
local overseer = require("overseer");
local function get_cwd_as_name()
  local dir = vim.fn.getcwd(0)
  return dir:gsub("[^A-Za-z0-9]", "_")
end

M.pre_write = function()
  overseer.save_task_bundle(get_cwd_as_name(), nil, { on_conflict = "overwrite" })
end
M.pre_read = function()
  for _, task in ipairs(overseer.list_tasks({})) do
    task:dispose(true)
  end
end
M.post_read = function()
  overseer.load_task_bundle(get_cwd_as_name(), { ignore_missing = true })
end
return M
