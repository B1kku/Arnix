return {
  {
    "saghen/blink.cmp",
    version = "*",
    -- build = "nix run .#build-plugin",
    config = function()
      local border = "rounded"
      local config = {
        -- don't autocomplete when I'm just moving my cursor pls
        keymap = {
          preset = "enter",
          ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
          ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
          ["<C-d>"] = { "scroll_documentation_down", "fallback" },
          ["<C-f>"] = { "scroll_documentation_up", "fallback" }
        },
        completion = {
          list = {
            selection = {
              preselect = false,
              auto_insert = false
            }
          },
          menu = {
            border = border,
            draw = {
              treesitter = { "lsp" }
            }
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
            window = {
              border = border
            }
          },
          ghost_text = {
            enabled = true
          }
        },
        signature = {
          window = {
            border = border,
            show_documentation = true
          },
          enabled = true
        }
      }
      require("blink.cmp").setup(config)
    end
    -- opts_extend = { "sources.default" }
  }
}
