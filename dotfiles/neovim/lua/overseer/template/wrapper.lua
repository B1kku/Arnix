local template = require("overseer.template")

local cwd = nil;

local templates_list = {}
local update_templates = function()
  templates_list = {}
  template.list(
    { tags = nil, dir = vim.fn.getcwd(), nil },
    function(templates)
      for _, tmpl in ipairs(templates) do
        table.insert(templates_list, tmpl.name)
      end
    end
  )
  vim.notify(vim.inspect(templates_list))
end


return {
  name = "Wrapper",
  builder = function(params)
    return {
      cmd = { "echo" },
      args = { "Starting Tasks" },
      components = { { "dependencies", task_names = params.tasks, sequential = params.sequential }, "on_exit_set_status" },
    }
  end,
  desc = "Chain tasks toguether",
  params = {
    tasks = {
      type = "list",
      subtype = {
        type = "enum",
        choices = templates_list
      }
    },
    sequential = {
      type = "boolean"
    }
  },
  condition = {
    callback = function(search)
      if (cwd ~= vim.fn.getcwd()) then
        cwd = vim.fn.getcwd()
        update_templates()
      end
      return true;
    end

  }
}
