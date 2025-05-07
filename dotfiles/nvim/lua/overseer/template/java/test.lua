return {
  name = "Test",
  builder = function(params)
    return {
      cmd = { "echo" },
      args = { "done" },
      components = { { "on_complete_notify" }, "default" },
    }
  end,
  desc = "Just debug",
  -- tags = (overseer.TAG.BUILD),
}
