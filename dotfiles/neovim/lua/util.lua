local M = {}

--- Returns whether a path is a subpath of another
---@param child string
---@param parent string
---@return boolean
function M.is_subdir(child, parent)
  return parent:sub(1, #child) == child
end






return M
