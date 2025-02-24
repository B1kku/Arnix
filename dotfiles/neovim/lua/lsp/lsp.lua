local function load_lsps(lsp_list, default_config)
  -- TODO: Technically incorrect? It's language settings, as in, formatter and linter also go there.
  -- Changing it does mean I might have to make a map of lsp -> language or language -> lsp so everyone can find their files.
  local lsp_config_dir = "lsp.lsp-config."
  local lspconfig = require("lspconfig")
  local function load_lsp(lsp)
    local config_found, language_config = pcall(require, lsp_config_dir .. lsp)
    local lsp_config = config_found and language_config["lsp_setup"] or {}
    lspconfig[lsp].setup(vim.tbl_deep_extend("force", default_config, lsp_config))
  end
  vim.tbl_map(load_lsp, lsp_list)
end

-- Set LSP Icons
local function set_signs(lsp_signs)
  for type, icon in pairs(lsp_signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
end

-- Given a list of {mode, key, action, opts, (extra_opts)},
-- add said keymap when the lsp attaches.
local function set_keymaps_on_attach(keymaps)
  local function set_keymap(keymap)
    local mode = keymap[1]
    local key = keymap[2]
    local action = keymap[3]
    local opts = { buffer = true, desc = keymap[4] }
    local extra_opts = keymap[5]
    if extra_opts then
      opts = vim.tbl_extend("force", opts, extra_opts)
    end
    vim.keymap.set(mode, key, action, opts)
  end
  vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP Keymaps",
    callback = function()
      vim.tbl_map(set_keymap, keymaps)
    end
  })
end
local nix_enabled = vim.g.nixvars ~= nil
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
      local borders = vim.g.border
      local default_config = {
        capabilities = capabilities,
        handlers = {
          ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = borders }),
          ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = borders })
        },
        on_attach = function(client, bufnr)
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr })
          end
        end
      }
      -- Map of signs for the LSP.
      local signs = { Error = "󰅚", Warn = "󰀪", Hint = "󰌶", Info = "" }

      local keymaps = {
        { "n", "K",    vim.lsp.buf.hover,           "Display information of symbol" },
        { "n", "gd",   vim.lsp.buf.definition,      "Go to definition" },
        { "n", "gD",   vim.lsp.buf.declaration,     "Go to declaration" },
        { "n", "gi",   vim.lsp.buf.implementation,  "Get implementations" },
        { "n", "go",   vim.lsp.buf.type_definition, "Go to definition" },
        { "n", "gr",   vim.lsp.buf.references,      "Get references" },
        { "n", "gs",   vim.lsp.buf.signature_help,  "Get signature info" },
        { "n", "gl",   vim.diagnostic.open_float,   "Get diagnostics on float" },
        { "n", "<F2>", vim.lsp.buf.rename,          "Rename" },
        { "n", "<F4>", vim.lsp.buf.code_action,     "Get code actions" },
        { "n", "[d",   vim.diagnostic.goto_prev,    "Previous diagnostic" },
        { "n", "]d",   vim.diagnostic.goto_next,    "Next diagnostic" },
      }

      load_lsps(lsp_list, default_config)
      set_signs(signs)
      set_keymaps_on_attach(keymaps)
    end
  },
  {
    -- Java lsp plugin. --
    -- I'm not sure why, but loading the config from here won't work
    -- Instead it's loaded from ftplugin/java
    "mfussenegger/nvim-jdtls",
    ft = "java"
  }
}
