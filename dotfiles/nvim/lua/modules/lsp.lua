local M = {}
-- Given a list of lsp names and a default config
-- Load them using lspconfig and a global config if one exists
---@param lsp_list string[]
---@param default_config table
function M.setup_lsps(lsp_list, default_config)
  -- TODO: Technically incorrect? It's language settings, as in, formatter and linter also go there.
  -- Changing it does mean I might have to make a map of lsp -> language or language -> lsp so everyone can find their files.
  local lsp_config_dir = "lsp.lsp-config."
  local lspconfig = require("lspconfig")
  local function setup_lsp(lsp)
    local config_found, language_config = pcall(require, lsp_config_dir .. lsp)
    local lsp_config = config_found and language_config["lsp_setup"] or {}
    lspconfig[lsp].setup(vim.tbl_deep_extend("force", default_config, lsp_config))
  end

  vim.tbl_map(setup_lsp, lsp_list)
end

---@alias simple_keymap [string, string, function|string, string, vim.keymap.set.Opts?]
-- Given a list of keymaps, setup an autocmd to attach them
-- when the lsp is attached
---@param keymaps simple_keymap[]
function M.set_keymaps_on_attach(keymaps)
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

local util = require("util")
-- Given a path, return whether or not it's a neovim config path
---@param root_dir string
---@return boolean
function M.is_vim_workspace(root_dir)
  if (not root_dir) then
    root_dir = vim.fn.getcwd(0)
  end
  local nix_config_dir = vim.tbl_get(vim.g, "nixvars", "config_dir")
  if (nix_config_dir and util.is_subdir(nix_config_dir, root_dir)) then
    return true
  end
  local config_dir = vim.fn.stdpath("config")
  if (util.is_subdir(root_dir, config_dir)) then
    return true
  end
  return false
end

return M
