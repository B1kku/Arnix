return {
  -- Better terminal integration, although a bit rough is very complete --
  "akinsho/toggleterm.nvim",
  keys = {
    { "<leader>t",  "<cmd>ToggleTerm<CR>",           "n", silent = true, desc = "Open terminal" },
    { "<leader>g",  "<cmd>lua Lazygit:toggle()<CR>", "n", silent = true, desc = "Open LazyGit" },
    { "<leader>n", "<cmd>lua Yazi:toggle()<CR>",    "n", silent = true, desc = "Open Yazi" }
  },
  config = function()
    local Terminal = require('toggleterm.terminal').Terminal
    local function set_terminal_keymaps(bufnr)
      local keymap = vim.api.nvim_buf_set_keymap
      keymap(bufnr, "t", "<esc>", [[<cmd>stopinsert<CR>]], { silent = true })
      keymap(bufnr, "t", "qq", [[<cmd>ToggleTerm<CR>]], { silent = true })
      keymap(bufnr, "t", "<C-w><Up>", [[<cmd>wincmd k<CR>]], { silent = true })
    end
    local nvim_integration = "EDITOR=" .. vim.fn.stdpath("config") .. "/nvim-remote-wrapper.sh"
    Yazi = Terminal:new({
      cmd = nvim_integration .. " yazi",
      direction = "float",
      hidden = true
    })

    Lazygit = Terminal:new({
      cmd = nvim_integration .. " lazygit",
      direction = "float",
      hidden = true
    })

    require("toggleterm").setup({
      direction = "horizontal",
      start_in_insert = true,
      on_open = function(term)
        set_terminal_keymaps(term.bufnr)
      end
    })
    -- vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
  end
}
