return {
  name = "Go build",
  desc = "Compile the go project",
  params = {
    file = {
      type = "string"
    }
  },
  builder = function(params)
    return {
      cmd = { "go" },
      args = { "build", params.file },
      components = { "default" }
    }
  end,
  condition = {
    callback = function(search)
      return next(vim.fs.find({ 'go.mod' }, { upward = true }))
    end
  }
}
