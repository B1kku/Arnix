return {
  -- Better terminal integration, although a bit rough is very complete --
  "akinsho/toggleterm.nvim",
  -- Don"t like default mapping config, can't limit modes.
  keys = {
    { "<leader>t", "<cmd>ToggleTerm<CR>", "n", silent = true, desc = "Open terminal" }
  },
  config = function()
    local function set_terminal_keymaps(bufnr)
      local keymap = vim.api.nvim_buf_set_keymap
      keymap(bufnr, "t", "<esc>", [[<cmd>stopinsert<CR>]], {silent = true})
      keymap(bufnr, "t", "qq", [[<cmd>ToggleTerm<CR>]], { silent = true })
      keymap(bufnr, "t", "<C-w><Up>", [[<cmd>wincmd k<CR>]], { silent = true })
    end

    require("toggleterm").setup({
      direction = "horizontal",
      -- shell = "bash",
      start_in_insert = true,
      on_open = function(term)
        set_terminal_keymaps(term.bufnr)
      end
    })
    -- vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
  end
}
