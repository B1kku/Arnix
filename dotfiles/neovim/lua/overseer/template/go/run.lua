return {
  name = "Go run",
  desc = "Compile and run the project",
  params = {
    file = {
      type = "string"
    },
    args = {
      type = "list",
      optional = true
    }
  },
  builder = function(params)
    local args = { "run", params.file }
    if (params.args ~= nil) then
      args = vim.list_extend(args, params.args)
    end
    return {
      cmd = { "go" },
      args = args,
      components = { "default" }
    }
  end,
  -- tags = (overseer.TAG.BUILD),
  condition = {
    callback = function(search)
      return next(vim.fs.find({ 'go.mod' }, { upward = true }))
    end
  }
}
