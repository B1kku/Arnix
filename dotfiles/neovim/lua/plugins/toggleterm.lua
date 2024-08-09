return {
  "akinsho/toggleterm.nvim",
  keys = {
    { "<leader>t", "<cmd>ToggleTerm<CR>",                          "n", silent = true, desc = "Open terminal" },
    { "<leader>g", "<cmd>lua Terminals[\"lazygit\"]:toggle()<CR>", "n", silent = true, desc = "Open LazyGit" },
    { "<leader>n", "<cmd>lua Terminals[\"yazi\"]:toggle()<CR>",    "n", silent = true, desc = "Open Yazi" }
  },
  config = function()
    local Terminal = require('toggleterm.terminal').Terminal
    -- Controls the extended logic for toggleterm.
    local toggleterm_module = require('modules.toggleterm')
    -- Holds all extra terminals defined.
    Terminals = {}
    -- These should be modules present in lua/terminals
    local terminal_list = { "lazygit", "yazi" }
    -- Define terminal specific keys here.
    local terminal_keys = function(terminal)
      return {
        { "t", "<esc><esc>", [[<cmd>stopinsert<cr>]], { desc = "Go into normal mode" } },
        { "t", "<C-w><Up>",  [[<cmd>wincmd k<cr>]],   { desc = "Change to the window above" } },
        {
          "t",
          "qq",
          "",
          {
            desc = "Toggle terminal",
            callback = function()
              terminal:toggle()
            end
          }
        },
        { "t", "<esc>", "", {
          desc = "Send esc to terminal",
          callback = function()
            local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
            vim.fn.chansend(terminal.job_id, esc)
          end
        } }
      }
    end
    -- Default config for all terminal keys
    local terminal_key_opts = { silent = true }
    -- Default config for all terminals
    local default_terminal_opts = {
      env = { EDITOR = vim.fn.stdpath("config") .. "/nvim-remote-wrapper.sh" },
      direction = "float",
      hidden = true,
      float_opts = {
        border = (vim.g.border == "rounded") and "curved" or vim.g.border
      },
      on_open = function(term)
        toggleterm_module.set_terminal_keymaps(term, terminal_keys(term), terminal_key_opts)
      end
    }
    require("toggleterm").setup(
      vim.tbl_extend("force", default_terminal_opts, {
        start_in_insert = true,
        autochdir = true,
        highlights = {
          FloatBorder = {
            link = "TelescopeBorder"
          }
        }
      })
    )
    Terminals = toggleterm_module.create_terminals(Terminal, terminal_list, default_terminal_opts)
  end
}
