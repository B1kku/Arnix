local telescope = [[<cmd>Telescope ]]
return {
  { "nvim-lua/plenary.nvim",                        lazy = true },
  { "nvim-telescope/telescope-live-grep-args.nvim", lazy = true },
  { "nvim-telescope/telescope-fzf-native.nvim",     lazy = true, build = "make" },
  -- Telescope, find anything. --
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = { "Telescope" },
    keys = {
      { "<leader>ff", telescope .. "find_files<cr>",     "n", silent = true, desc = "Find files" },
      { "<leader>fa", telescope .. "git_files<cr>",      "n", silent = true, desc = "Git files" },
      { "<leader>fg", telescope .. "live_grep<cr>",      "n", silent = true, desc = "Find+grep" },
      { "<leader>fh", telescope .. "help_tags<cr>",      "n", silent = true, desc = "Find help" },
      { "<leader>fs", telescope .. "live_grep_args<CR>", "n", silent = true, desc = "Live grep" }
    },
    config = function()
      local live_grep = require("telescope-live-grep-args.actions")
      --Telescope doesn't use nvim_open_win parameters, this fixes it...
      -- TODO: Move to proper setting once this is fixed.
      -- https://github.com/nvim-telescope/telescope.nvim/issues/3436
      local fixedborder = vim.g.borderchars
      for i = 1, 4, 1 do
        fixedborder[i] = vim.g.borderchars[i * 2]
        fixedborder[i + 4] = vim.g.borderchars[i * 2 - 1]
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
          -- borderchars = fixedborder,
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
              i = { ["<C-a>"] = live_grep.quote_prompt({ postfix = " --iglob **" }) },
            },
          },
        },
      }
    end
  }
}
