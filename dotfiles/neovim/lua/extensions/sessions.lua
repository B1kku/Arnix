local M = {}
local telescope = require("telescope.themes").get_dropdown()
local actions_state = require("telescope.actions.state")
local directory = MiniSessions.config.directory

local function format_name(name)
  return name:sub(1, 1):upper() .. name:sub(2)
end

local function get_detected_names()
  -- Reload sessions
  MiniSessions.setup()
  local sessions_list = {}
  local sessions = MiniSessions.detected
  if sessions ~= nil then
    local i = 0
    for key, _ in pairs(sessions) do
      i = i + 1
      sessions_list[i] = key
    end
  end
  return sessions_list
end

local function get_selected()
  return actions_state.get_selected_entry()
end

local function get_picker()
  return actions_state.get_current_picker(vim.api.nvim_get_current_buf())
end


local function rename_session()
  -- Missing session, AKA get current picker's selected value
  local selected = get_selected()
  local session = selected.value
  vim.ui.input({ prompt = 'Rename ' .. session .. " to:" }, function(input)
    if input then
      input = format_name(input)
      os.rename(directory .. "\\" .. session, directory .. "\\" .. input)
      -- MiniSessions.setup()
      selected.value = input
      selected.display = format_name(selected.value)
      selected.ordinal = selected.display
      get_picker():refresh()
    end
  end)
end

local function delete_session()
  local picker = get_picker()
  picker:delete_selection(function(selection)
    MiniSessions.delete(selection.value)
  end)
end

local function create_session()
  local picker = get_picker()
  local prompt = picker:_get_prompt()
  local session = nil
  if prompt ~= "" then
    session = prompt
  else
    session = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  end
  local results = picker.finder.results
  MiniSessions.write(format_name(session))
  local entry = {}
  entry.value = session
  entry.display = format_name(session)
  entry.ordinal = entry.display
  entry.index = #results + 1
  results[entry.index] = entry
  picker:reset_prompt("")
end


function M.open(keys)
  telescope.attach_mappings = function(_, map)
    map("i", keys.delete, delete_session)
    map("i", keys.save, create_session)
    map("i", keys.rename, rename_session)
    return true
  end

  vim.ui.select(
    get_detected_names(),
    {
      prompt = 'Select a Session',
      telescope = telescope,
      format_item = format_name
    },
    function(choice)
      if choice then
        MiniSessions.read(choice)
      end
    end)
end

return M
