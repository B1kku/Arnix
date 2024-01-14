return {
  -- Indent markers --
  "lukas-reineke/indent-blankline.nvim",
  config = function()
    require("ibl").setup {
      -- space_char_blankline = " ",
      -- show_current_context = true,
      -- show_current_context_start = true,
    }
    -- vim.g.indent_blankline_char = ""
    -- vim.cmd[[highlight IblIndent guifg=#c167d9 gui=nocombine]]
    -- Very needed if I wasn't using current context only.
    -- vim.g.indent_blankline_max_indent_increase = 1
  end
}
