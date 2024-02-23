return {
  name = "Rsync to",
  desc = "Move a glob to another directory",
  builder = function(params)
    -- local expandcmd = vim.fn.expandcmd
    local args = { "-n", "-P" }
    if params.chown ~= nil then
      local chown_params = { "-og", "--chown=" .. params.chown }
      vim.list_extend(args, chown_params)
    end
    if params.extra then
      args = vim.tbl_extend("keep", args, params.extra)
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
    extra = {
      type = "list",
      subtype = {
        type = "string"
      },
      delimiter = ",",
      order = 4,
      optional = true
    },
  }
}
