local jdtls_ok, jdtls = pcall(require, "jdtls")
if not jdtls_ok then
  vim.notify "JDTLS not found, install with `:MasonInstall jdtls`"
  return
end
local config = require("lsp.lsp-config.jdtls")

jdtls.start_or_attach(config)
