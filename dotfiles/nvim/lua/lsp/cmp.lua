return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip"
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      --Required by cmp
      vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
      require("luasnip/loaders/from_vscode").lazy_load()
      cmp.setup {
        --Snippets
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body) --luasnip setup.
          end,
        },
        --Places to populate completions from.
        sources = cmp.config.sources({
          { name = "luasnip" },
          { name = "nvim_lsp" },
          -- { name = "nvim_lsp_signature_help" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),

        window = {
          completion = {
            border = vim.g.borderchars
          },
          documentation = {
            border = vim.g.borderchars
          }
        },
        experimental = {
          ghost_text = true
        },
        --Mappings
        mapping = cmp.mapping.preset.insert({
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ["<C-e>"] = cmp.mapping.abort(),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
              -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
              -- they way you will only jump inside the snippet region
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
              -- elseif has_words_before() then
              --   cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
      }
    end
  }
}

-- local has_words_before = function()
--   unpack = unpack or table.unpack
--   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
-- end

-- 󰃐 󰆩 󰙅 󰛡  󰅲 some other good icons
-- local kind_icons = {
--   Text = "󰉿",
--   Method = "m",
--   Function = "󰊕",
--   Constructor = "",
--   Field = "",
--   Variable = "󰆧",
--   Class = "󰌗",
--   Interface = "",
--   Module = "",
--   Property = "",
--   Unit = "",
--   Value = "󰎠",
--   Enum = "",
--   Keyword = "󰌋",
--   Snippet = "",
--   Color = "󰏘",
--   File = "󰈙",
--   Reference = "",
--   Folder = "󰉋",
--   EnumMember = "",
--   Constant = "󰇽",
--   Struct = "",
--   Event = "",
--   Operator = "󰆕",
--   TypeParameter = "󰊄",
-- }
