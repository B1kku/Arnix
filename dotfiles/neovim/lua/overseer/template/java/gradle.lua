return {
  name = "Gradle Build",
  desc = "Build with Gradle",
  builder = function(params)
    return {
      cmd = { "gradle" },
      args = { "build" },
      components = { "default" }
    }
  end,
  -- tags = (overseer.TAG.BUILD),
  condition = {
    callback = function(search)
      return next(vim.fs.find({ 'build.gradle', 'build.gradle.kts' }, { upward = true }))
    end
  }
}
