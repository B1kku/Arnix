local telescope = [[<cmd>lua require("telescope.builtin").]]
return {
  -- Telescope, find anything. --
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    {"nvim-lua/plenary.nvim"},
    {"nvim-telescope/telescope-live-grep-args.nvim"},
    {"nvim-telescope/telescope-fzf-native.nvim", build = "make"}
  },
  keys = {
    {"<leader>ff", telescope .. "find_files()<cr>", "n", silent = true, desc = "Find files"},
    {"<leader>fa", telescope .. "git_files()<cr>", "n", silent = true, desc = "Git files"},
    {"<leader>fg", telescope .. "live_grep()<cr>", "n", silent = true, desc = "Find+grep"},
    {"<leader>fh", telescope .. "help_tags()<cr>", "n", silent = true, desc = "Find help"},
    {"<leader>fs", [[<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>]], "n", silent = true, desc = "Live grep"}
  },
  config = function()
    local live_grep = require("telescope-live-grep-args.actions")
    --Telescope doesn't use nvim_open_win parameters, this fixes it...
    local fixedborder = vim.g.borderchars
    for i = 1, 4, 1 do
      fixedborder[i] = vim.g.borderchars[i*2]
      fixedborder[i+4] = vim.g.borderchars[i*2-1]
    end
    require("telescope").setup {
      defaults = {
        mappings = {
          i = {
            -- C-u it's not very ergonomic for scrolling up.
            ["<C-f>"] = "preview_scrolling_up",
            ["<C-h>"] = "which_key",
            ["qq"] = "close"
          }
        },
        borderchars = fixedborder,
        layout_config = {
          horizontal = {
            preview_cutoff = 0,
          },
        },
      },
      extensions = {
        live_grep_args = {
          mappings = {
            -- Adds directory filter
            i = {["<C-a>"] = live_grep.quote_prompt({ postfix = " --iglob **" })},
          },
        },
      },
    }
    require("telescope").load_extension("live_grep_args")
  end
}

