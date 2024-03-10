local jdtls_ok = pcall(require, "jdtls")
if not jdtls_ok then
  vim.notify "JDTLS not found, install with `:MasonInstall jdtls`"
  return
end
local config = require("lsp.languages.java")

require('jdtls').start_or_attach(config)
-- This is due to nix's jdtls package being called jdt-language-server, not jdtls like it should... ._.

