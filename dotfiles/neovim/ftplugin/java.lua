local jdtls_ok = pcall(require, "jdtls")
if not jdtls_ok then
  vim.notify "JDTLS not found, install with `:MasonInstall jdtls`"
  return
end
--[[ TODO: Add windows support again...?
I pretty much scrapped a huge part of the config since I don't rely on mason anymore.
Idk if some of the options passed were part of the culprit for some issues.
Won't touch more options if I don't need to, lombok is added through nixos.]]--
local config = {
  cmd = { 'jdtls' },
  root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
}
require('jdtls').start_or_attach(config)
