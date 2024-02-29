return {
  -- Maps programming objects to a tree like structure, for easier interaction with them.
  "nvim-treesitter/nvim-treesitter",
  enabled = true,
  build = ":TSUpdate",
  config = function()
    if (vim.g.nixvars) then
      require('nvim-treesitter.install').compilers = { "gcc" }
    end
    require("nvim-treesitter.configs").setup({
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = {
        enable = true
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          }
        },
      },
      ensure_installed = {
        "json",
        "vimdoc",
        "yaml",
        "lua",
        "python",
        "nix",
        "java",
        "markdown"
      }
    })
  end
}
