-- I'm half sure nix wrapper for jdtls doesn't give a crap about data directory.
-- ps ax | grep java (somewhat debug startup command)

local env = {
  HOME = vim.loop.os_homedir(),
  XDG_CACHE_HOME = os.getenv 'XDG_CACHE_HOME',
  JDTLS_JVM_ARGS = os.getenv 'JDTLS_JVM_ARGS',
}
local function get_cache_dir()
  return env.XDG_CACHE_HOME and env.XDG_CACHE_HOME or vim.fs.joinpath(env.HOME, '.cache')
end

local function get_jdtls_cache_dir()
  return vim.fs.joinpath(get_cache_dir(), 'jdtls')
end

local function get_jdtls_config_dir()
  return vim.fs.joinpath(get_jdtls_cache_dir(), 'config')
end

local function get_jdtls_workspace_dir()
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
  return vim.fs.joinpath(get_jdtls_cache_dir(), project_name)
end
local function get_jdtls_jvm_args()
  local args = {}
  for a in string.gmatch((env.JDTLS_JVM_ARGS or ''), '%S+') do
    local arg = string.format('--jvm-arg=%s', a)
    table.insert(args, arg)
  end
  return unpack(args)
end

local cmd = {
  'jdtls',
  '-configuration',
  get_jdtls_config_dir(),
  '-data',
  get_jdtls_workspace_dir(),
  get_jdtls_jvm_args(),
}
local config = {
  cmd = cmd,
  root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
  capabilities = require('blink.cmp').get_lsp_capabilities(),
  inlayHints = {
    parameterNames = { enabled = "all" }
  },
  settings = {
    java = {
      saveActions = {
        organizeImports = true
      },
      configuration = {
        runtimes = {

        }
      },
    }
  }
}

for key, value in pairs(vim.g.nixvars.java_runtimes) do
  table.insert(config.settings.java.configuration.runtimes,
    { name = "JavaSE-" .. key, path = value .. "/lib/openjdk/" })
end
return config
