local default_args = {
  "-Werror",
  "-Wextra", "-Wall", -- essential.
  "-Wfloat-equal",
  "-Wundef",
  "-Wshadow",
  "-Wpointer-arith",
  "-Wcast-align",
  "-Wstrict-prototypes",
  "-Wstrict-overflow=5",
  "-Wwrite-strings",
  "-Waggregate-return",
  "-Wcast-qual",
  "-Wswitch-default",
  "-Wswitch-enum",
  "-Wconversion",
  "-Wunreachable-code",
  "-O2"
}
local name = "Gcc Compile"
return {
  name = name,
  desc = "Compile C",
  params = {
    file = {
      type = "string"
    },
    args = {
      type = "list",
      default = default_args,
      optional = true
    }
  },
  builder = function(params)
    local outname = vim.fn.fnamemodify(params.file, ":t:r")
    local args = { params.file, "-o", outname }
    args = vim.list_extend(params.args, args)
    return {
      name = name,
      cmd = { "gcc" },
      args = args,
      components = { "default" }
    }
  end,
  condition = {
    callback = function(search)
      local c = vim.fs.find(function(name, path)
        return name:match('.*%.c$')
      end, { type = 'file' })
      return next(c)
    end
  }

  -- tags = (overseer.TAG.BUILD),
}
