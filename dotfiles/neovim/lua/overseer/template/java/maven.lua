return {
  name = "Maven Package",
  builder = function(params)
    return {
      cmd = { "mvn" },
      args = { "package" },
      components = { {"on_complete_notify", system = "always"}, "default" }
    }
  end,
  desc = "Package with Maven",
  -- tags = (overseer.TAG.BUILD),
  condition = {
    callback = function(search)
      return next(vim.fs.find({ 'pom.xml' }, { upward = true }))
    end
  }
}
