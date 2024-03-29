return {
  -- Better terminal integration, although a bit rough is very complete --
  "akinsho/toggleterm.nvim",
  keys = {
    { "<leader>t", "<cmd>ToggleTerm<CR>",           "n", silent = true, desc = "Open terminal" },
    { "<leader>g", "<cmd>lua Lazygit:toggle()<CR>", "n", silent = true, desc = "Open LazyGit" },
    { "<leader>n", "<cmd>lua Yazi:toggle()<CR>",    "n", silent = true, desc = "Open Yazi" }
  },
  config = function()
    local Terminal = require('toggleterm.terminal').Terminal
    local nvim_integration = "EDITOR=" .. vim.fn.stdpath("config") .. "/nvim-remote-wrapper.sh"
    local terminals = {}

    local function set_terminal_keymaps(terminal)
      local keymap = vim.api.nvim_buf_set_keymap
      local bufnr = terminal.bufnr
      keymap(bufnr, "t", "<esc><esc>", [[<cmd>stopinsert<CR>]], { silent = true })
      -- Lua won't pickup the terminal variable from this scope without callback
      keymap(bufnr, "t", "qq", "", {
        silent = true,
        callback = function()
          terminal:toggle()
        end
      })
      keymap(bufnr, "t", "<C-w><Up>", [[<cmd>wincmd k<CR>]], { silent = true })
    end

    Yazi = Terminal:new({
      cmd = nvim_integration .. " yazi",
      direction = "float",
      hidden = true,
      on_open = function(term)
        set_terminal_keymaps(term)
      end
    })

    Lazygit = Terminal:new({
      cmd = nvim_integration .. " lazygit",
      direction = "float",
      hidden = true,
      on_open = function(term)
        set_terminal_keymaps(term)
      end
    })

    table.insert(terminals, Lazygit)
    table.insert(terminals, Yazi)
    -- Refresh cwd of these terminals too
    vim.api.nvim_create_autocmd({ "DirChanged" }, {
      callback = function()
        local cwd = vim.fn.getcwd()
        for _, term in ipairs(terminals) do
          if (term.dir and term.dir ~= cwd) then
            term:change_dir(cwd)
            term:shutdown()
          end
        end
      end
    })

    require("toggleterm").setup({
      direction = "float",
      start_in_insert = true,
      autochdir = true,
      on_open = function(term)
        set_terminal_keymaps(term)
      end,
      highlights = {
        FloatBorder = {
          link = "TelescopeBorder"
        }
      }
    })
    -- vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
  end
}
