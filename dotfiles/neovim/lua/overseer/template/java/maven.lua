return {
  name = "Maven Package",
  desc = "Package with Maven",
  builder = function(params)
    return {
      cmd = { "mvn" },
      args = { "package" },
      components = { "direnv", "default" }
    }
  end,
  -- tags = (overseer.TAG.BUILD),
  condition = {
    callback = function(search)
      return next(vim.fs.find({ 'pom.xml' }, { upward = true }))
    end
  }
}
