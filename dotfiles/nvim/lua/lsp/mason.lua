return {
  -- LSP/DAP/Linter/Formatter Installer
  "williamboman/mason.nvim",
  build = ":MasonUpdate",
  lazy = false,
  config = function()
    require("mason").setup {
      -- Prefer system installed LSPs, mainly for portability with NixOS
      PATH = "append";
      pip = {
        upgrade_pip = true
      },
      ui = {
        border = vim.g.border
      }
    }
  end
}
