return {
  name = "Test",
  builder = function(params)
    return {
      cmd = { "echo" },
      args = { "done" },
      components = { {"on_complete_notify", system = "always"}, "default" }
    }
  end,
  desc = "Just debug",
  -- tags = (overseer.TAG.BUILD),
}
