local nix_enabled = vim.g.nixvars ~= nil
return {
  {
    -- LSP/DAP/Linter/Formatter Installer
    -- Only kept enabled under nix because I honestly
    -- like it as a tool to find "curated" language tools
    "williamboman/mason.nvim",
    build = nix_enabled and "" or ":MasonUpdate",
    cmd = { "Mason" },
    config = function()
      local mason_config = {
        ui = {
          border = vim.g.border
        }
      }
      if not nix_enabled then
        mason_config.pip = {
          upgrade_pip = true
        }
      end
      -- Prefer system installed LSPs, mainly for portability with NixOS
      if nix_enabled then
        mason_config.PATH = "append"
      end
      require("mason").setup(mason_config)
    end
  },
}
