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
      keymap(bufnr, "t", "qq", [[<cmd>q<CR>]], { silent = true })
      keymap(bufnr, "t", "<C-w><Up>", [[<cmd>wincmd k<CR>]], { silent = true })
      -- Bash hangs sometimes so this is a workaround to kill the terminal when it's being dumb
      keymap(bufnr, "t", "<C-x>", [[<cmd>TermExec cmd=exit<CR>]], { silent = true })
    end
    require("toggleterm").setup({
      direction = "horizontal",
      shell = "bash",
      start_in_insert = true,
      on_open = function(term)
        set_terminal_keymaps(term.bufnr)
      end
    })
    -- vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
  end
}
