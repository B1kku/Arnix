return {
  -- Maps programming objects to a tree like structure, for easier interaction with them.
  "nvim-treesitter/nvim-treesitter",
  config = function()
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
        "lua",
        "python",
        "nix",
        "java",
        "markdown"
      }
    })
  end
}
