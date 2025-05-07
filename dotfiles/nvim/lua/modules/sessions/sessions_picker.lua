local M = {}

local minisessions = require("mini.sessions")
local picker = nil

local opts = {
  keys = {
    actions = {
      delete = { "i", "<C-d>" },
      rename = { "i", "<C-r>" },
      create = { "i", "<C-s>" },
    },
    custom = {}
  }
}

function M.setup(user_opts)
  if user_opts == nil then return end
  if type(user_opts) == "function" then
    user_opts = user_opts()
  end
  vim.tbl_deep_extend("force", user_opts, opts)
end

local function get_actions()
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"
  return {
    select = function(prompt_bufnr)
      actions.close(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      minisessions.read(selection.value.name)
    end,
    -- https://github.com/nvim-telescope/telescope.nvim/issues/3384 Can't delete entries, so ig refresh the whole thing
    delete = function(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      local current_picker = action_state.get_current_picker(prompt_bufnr)
      minisessions.delete(selection.value.name)
      current_picker:refresh(current_picker.finder, { reset_prompt = false })
    end,
    rename = function(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      local current_picker = action_state.get_current_picker(prompt_bufnr)
      vim.ui.input({ prompt = "New session name:" }, function(input)
        if not input or input == "" then
          return
        end
        local session_file = selection.value.path
        local path = vim.fn.fnamemodify(session_file, ":h")
        path = vim.fs.joinpath(path, input)

        local new_session = selection.value
        new_session.name = input
        new_session.path = path
        minisessions.detected[input] = new_session
        minisessions.detected[selection.value.name] = nil
        os.rename(session_file, path)

        current_picker:refresh(current_picker.finder, { reset_prompt = false })
      end)
    end,
    create = function(prompt_bufnr)
      local prompt = action_state.get_current_line()
      local session = nil
      if prompt ~= "" then
        session = prompt
      else
        session = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      end
      minisessions.write(session)
      local current_picker = action_state.get_current_picker(prompt_bufnr)
      current_picker:refresh(current_picker.finder, { reset_prompt = true })
    end
  }
end

local function new_picker(telescope_opts)
  local pickers = require "telescope.pickers"
  local finders = require "telescope.finders"
  local conf = require("telescope.config").values
  local actions = require "telescope.actions"

  telescope_opts = telescope_opts or {}
  local key_actions = get_actions()
  local attach_mappings = function(_, map)
    actions.select_default:replace(key_actions.select)
    for key, value in pairs(opts.keys.actions) do
      -- TODO: Proper message
      if not key_actions[key] then
        vim.print("Error: Session picker's keys.actions contained non-action key")
        return false
      end
      map(value[1], value[2], key_actions[key], unpack(value, 3, #value))
    end

    for _, value in ipairs(opts.keys.custom) do
      map(unpack(value))
    end

    return true
  end

  local finder = finders.new_dynamic {
    fn = function()
      local sessions = vim.tbl_values(minisessions.detected)
      table.sort(sessions, function(session, session_next)
        return session.modify_time > session_next.modify_time
      end)
      return sessions
    end,
    entry_maker = function(entry)
      return {
        value = entry,
        display = entry.name,
        ordinal = entry.name
      }
    end
  }
  return pickers.new(telescope_opts, {
    prompt_title = "Pick a session",
    finder = finder,
    sorter = conf.generic_sorter(telescope_opts),
    attach_mappings = attach_mappings
  })
end

M.open = function()
  local ok, telescope_themes = pcall(require, "telescope.themes")
  if not ok then
    vim.print("Error: Telescope wasn't found, using the default picker")
    M.open = minisessions.select
    return
  end
  picker = new_picker(telescope_themes.get_dropdown {})
  picker:find()
  M.open = function()
    picker:find()
  end
end
return M
