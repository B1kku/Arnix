local overseer = require("overseer")
local template = require("overseer.template")
local cwd = nil;

local function get_templates()
  local templates_list = {}
  if (cwd == nil) then return { "Not loaded yet" } end
  template.list(
    { dir = cwd },
    function(templates)
      for _, tmpl in ipairs(templates) do
        table.insert(templates_list, tmpl.name)
      end
    end
  )
  return templates_list
end

local wrapper_template = {
  name = "Wrapper",
  desc = "Chain templates together",
  builder = function(params)
    return {
      name = "Parent task",
      cmd = { "echo" },
      args = { "Starting Tasks" },
      components = { { "dependencies", task_names = params.templates, sequential = params.sequential }, "on_exit_set_status", "on_complete_notify" },
    }
  end,
  params = {
    templates = {
      type = "list",
      order = 1,
      subtype = {
        type = "enum",
        choices = get_templates()
      }
    },
    sequential = {
      type = "boolean"
    }
  }
}

local condition = {
  callback = function(search)
    if (cwd ~= vim.fn.getcwd()) then
      cwd = vim.fn.getcwd()
      wrapper_template.params.templates.subtype.choices = get_templates()
      overseer.register_template(wrapper_template)
    end
    return true
  end
}

wrapper_template.condition = condition
return wrapper_template
