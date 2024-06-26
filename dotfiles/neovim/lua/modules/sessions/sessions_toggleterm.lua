local M = {}
M.post_read = function()
  if Terminals == nil then return end
  for _, term in pairs(Terminals) do
    term.dir = vim.fn.getcwd()
    term:shutdown()
    if term.on_create then
      term:on_create(term)
    end
  end
end
return M
