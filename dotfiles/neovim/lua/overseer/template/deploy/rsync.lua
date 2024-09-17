return {
  name = "Rsync to",
  desc = "Move a glob to another directory",
  builder = function(params)
    -- local expandcmd = vim.fn.expandcmd
    local args = { "--dry-run", "-P", "-h" }
    if params.chown then
      local chown_params = { "-og", "--chown=" .. params.chown }
      vim.list_extend(args, chown_params)
    end
    if params.filter_file then
      local filter_file_param = string.format("--filter='merge %s'", params.filter_file)
      table.insert(args, filter_file_param)
    end
    if params.ru then
      vim.list_extend(args, {"-ru"})
    end
    if params.extra then
      vim.list_extend(args, params.extra)
    end
    table.insert(args, params.from)
    table.insert(args, params.to)
    return {
      name = "Rsync to " .. params.to,
      cmd = { "rsync" },
      args = args,
      components = { "default" }
    }
  end,
  params = {
    from = {
      type = "string",
      order = 1
    },
    to = {
      type = "string",
      order = 2
    },
    chown = {
      type = "string",
      optional = true,
      order = 3
    },
    filter_file = {
      type = "string",
      optional = true,
      default = ".rsync-filter",
      order = 4
    },
    ru = {
      type = "boolean",
      optional = true,
      order = 5
    },
    extra = {
      type = "list",
      subtype = {
        type = "string"
      },
      delimiter = ",",
      order = 6,
      optional = true
    },
  }
}
