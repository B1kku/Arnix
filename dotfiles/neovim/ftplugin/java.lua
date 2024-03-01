local util = require 'lspconfig.util'
local jdtls_ok = pcall(require, "jdtls")
if not jdtls_ok then
  vim.notify "JDTLS not found, install with `:MasonInstall jdtls`"
  return
end


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
  return util.path.join(get_jdtls_cache_dir(), 'workspace')
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


--[[ TODO: Add windows support again...?
I pretty much scrapped a huge part of the config since I don't rely on mason anymore.
Idk if some of the options passed were part of the culprit for some issues.
Won't touch more options if I don't need to, lombok is added through nixos.]]
local config = {
  cmd = cmd,
  root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
  capabilities = require("cmp_nvim_lsp").default_capabilities()
}
require('jdtls').start_or_attach(config)
-- This is due to nix's jdtls package being called jdt-language-server, not jdtls like it should... ._.

