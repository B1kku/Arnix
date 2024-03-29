return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "williamboman/mason-lspconfig.nvim"
    },
    -- vim.lsp.get_log_path() to get the log path.
    config = function()
      local mason_installs = { automatic_installation = true }
      -- Don't install lsps on nix, nix handles it.
      if vim.g.nixvars then
        mason_installs.automatic_installation = false
        require("mason-lspconfig").setup(mason_installs)
      end
      local lspconfig = require("lspconfig")
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
      -- LSP configs go here.
      -- Java is on ftplugin.
      -- Lua LSP. --
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = require("lsp.languages.lua").settings
      })
      lspconfig.pyright.setup({
        capabilities = capabilities
        -- settings = require("lsp.languages.python").settings
      })
      lspconfig.bashls.setup({
        capabilities = capabilities
      })
      lspconfig.nixd.setup({
        capabilities = capabilities
      })
      -- lspconfig.jdtls.setup({
      --   capabilities = capabilities,
      --   cmd = require("lsp.languages.java").cmd
      -- })
      --Keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP actions",
        callback = function()
          local bufmap = function(mode, lhs, rhs, desc)
            local opts = { buffer = true, desc = desc }
            vim.keymap.set(mode, lhs, rhs, opts)
          end
          -- bufmap("n", "<leader>sf", vim.lsp.buf.format, "Format current file")
          bufmap("n", "K", vim.lsp.buf.hover, "Display information of symbol")
          bufmap("n", "gd", vim.lsp.buf.definition, "Go to definition")
          bufmap("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
          bufmap("n", "gi", vim.lsp.buf.implementation, "Get implementations")
          bufmap("n", "go", vim.lsp.buf.type_definition, "Go to definition")
          bufmap("n", "gr", vim.lsp.buf.references, "Get references")
          bufmap("n", "gs", vim.lsp.buf.signature_help, "Get signature info")
          bufmap("n", "gl", vim.diagnostic.open_float, "Get diagnostics on float")
          bufmap("n", "<F2>", vim.lsp.buf.rename, "Rename")
          bufmap("n", "<F4>", vim.lsp.buf.code_action, "Get code actions")
          bufmap("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
          bufmap("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
        end
      })
      -- Set LSP Icons
      local signs = { Error = "󰅚", Warn = "󰀪", Hint = "󰌶", Info = "" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end
  },
  {
    -- Java lsp plugin. --
    "mfussenegger/nvim-jdtls",
    ft = "java",
    -- config = function ()
    --   require("lsp.languages.java")
    -- end
  }
}
