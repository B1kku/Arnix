return {
  -- LSP/DAP/Linter/Formatter Installer
  "williamboman/mason.nvim",
  build = ":MasonUpdate",
  lazy = false,
  config = function()
    local mason_config = {
      pip = {
        upgrade_pip = true
      },
      ui = {
        border = vim.g.border
      }
    }

    -- Prefer system installed LSPs, mainly for portability with NixOS
    if vim.g.nixvars then
      mason_config.PATH = "append"
    end
    require("mason").setup(mason_config)
  end
}
