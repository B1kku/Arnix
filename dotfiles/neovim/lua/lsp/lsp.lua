local nix_enabled = vim.g.nixvars ~= nil
local mod = require("modules.lsp")
return {
  {
    "williamboman/mason-lspconfig.nvim",
    enabled = not nix_enabled
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      -- Don't install lsps on nix, nix handles it.
      if not vim.g.nixvars then
        require("mason-lspconfig").setup({
          automatic_installation = true
        })
      end
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
      -- capabilities.textDocument.completion.completionItem.snippetSupport = true
      -- List of lsp to be loaded, if lsp_config_dir + lsp_name matches a file,
      -- it will override the default config.
      local lsp_list = {
        "pyright",
        "bashls",
        "nixd",
        "gopls",
        "clangd",
        "lua_ls",
        "yamlls",
        "rust_analyzer",
        "html",
        "cssls",
        "jsonls",
        "ts_ls"
      }
      -- Set lsp borders
      local default_config = {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr })
          end
        end
      }
      -- Setup diagnostic config
      local severity = vim.diagnostic.severity
      -- Map of signs for the LSP.
      ---@type vim.diagnostic.Opts
      local diagnostic_opts = {
        signs = {
          text = { [severity.ERROR] = "󰅚", [severity.WARN] = "󰀪", [severity.HINT] = "󰌶", [severity.INFO] = "" }
        },
        severity_sort = true,
        virtual_lines = { current_line = true },
      }

      local goto_next = function() vim.diagnostic.jump({ count = 1, float = true }) end
      local goto_prev = function() vim.diagnostic.jump({ count = -1, float = true }) end
      ---@type simple_keymap[]
      local keymaps = {
        { "n", "gd",   vim.lsp.buf.definition,      "Go to definition" },
        { "n", "gD",   vim.lsp.buf.declaration,     "Go to declaration" },
        { "n", "gi",   vim.lsp.buf.implementation,  "Get implementations" },
        { "n", "go",   vim.lsp.buf.type_definition, "Go to definition" },
        { "n", "gr",   vim.lsp.buf.references,      "Get references" },
        { "n", "gs",   vim.lsp.buf.signature_help,  "Get signature info" },
        { "n", "gl",   vim.diagnostic.open_float,   "Get diagnostics on float" },
        { "n", "<F2>", vim.lsp.buf.rename,          "Rename" },
        { "n", "<F4>", vim.lsp.buf.code_action,     "Get code actions" },
        { "n", "[d",   goto_prev,                   "Previous diagnostic" },
        { "n", "]d",   goto_next,                   "Next diagnostic" },
      }
      vim.diagnostic.config(diagnostic_opts)
      mod.setup_lsps(lsp_list, default_config)
      mod.set_keymaps_on_attach(keymaps)
    end
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library" }
      },
      enabled = function(root_dir)
        if (vim.g.lazydev_enabled) then
          return true
        end
        return mod.is_vim_workspace(root_dir)
      end
    }
  },
  {
    -- Java lsp plugin. --
    -- I'm not sure why, but loading the config from here won't work
    -- Instead it's loaded from ftplugin/java
    "mfussenegger/nvim-jdtls",
    ft = "java"
  }
}
