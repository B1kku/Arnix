local M = {}
local util = require("util")
local overriden_languages = {}

local blacklist = {}

local function format_node_selector(node)
  return util.strip(node):lower()
end

---@param args vim.api.keyset.create_autocmd.callback_args
local function find_folds(args)
  local type = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
  if (type ~= "") then
    return
  end
  local language = vim.api.nvim_get_option_value("filetype", { buf = args.buf })
  if (overriden_languages[language]) then
    return
  end
  overriden_languages[language] = true
  local files = vim.api.nvim_get_runtime_file("queries/" .. language .. "/folds.scm", true)
  -- There's already something trying to override these folds,
  -- or there's no folds for this language
  if (#files < 1) then
    return nil
  end
  local file = files[1]
  if (util.is_subdir(file, vim.fn.stdpath("config"))) then
    return
  end
  local fhandle = io.open(file, "r")
  if (fhandle == nil) then
    return
  end
  local new_query = ""

  for line in fhandle:lines() do
    local fline = format_node_selector(line)
    if (not blacklist[fline]) then
      new_query = new_query .. line .. "\n"
    end
  end
  fhandle:close()
  vim.treesitter.query.set(language, "folds", new_query)
end

function M.setup_folds(blacklisted_nodes)
  for _, value in ipairs(blacklisted_nodes) do
    blacklist[format_node_selector(value)] = true
  end
  -- Before each file open, get language
  vim.api.nvim_create_autocmd({ "FileType" }, { callback = find_folds })
end

return M
