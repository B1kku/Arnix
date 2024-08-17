-- This is due to nix's jdtls package being called jdt-language-server, not jdtls like it should... ._.
-- I'm half sure nix wrapper for jdtls doesn't give a crap about data directory.
local util = require 'lspconfig.util'

-- ps ax | grep java (somewhat debug startup command)

local env = {
  HOME = vim.loop.os_homedir(),
  XDG_CACHE_HOME = os.getenv 'XDG_CACHE_HOME',
  JDTLS_JVM_ARGS = os.getenv 'JDTLS_JVM_ARGS',
}
local function get_cache_dir()
  return env.XDG_CACHE_HOME and env.XDG_CACHE_HOME or util.path.join(env.HOME, '.cache')
end

local function get_jdtls_cache_dir()
  return util.path.join(get_cache_dir(), 'jdtls')
end

local function get_jdtls_config_dir()
  return util.path.join(get_jdtls_cache_dir(), 'config')
end

local function get_jdtls_workspace_dir()
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
  return util.path.join(get_jdtls_cache_dir(), project_name)
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
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  settings = {
    java = {
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
vim.g.jdtls = config
return config
