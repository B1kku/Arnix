--[[ init.lua ]]--

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local globals = vim.g

globals.mapleader = " "
globals.maplocalleader = " "

-- IMPORTS --
require("vars")     -- Variables
require("ftplugin") -- Filetypes definitions
require("opts")     -- Options
require("keys")     -- Keymaps

local lazy_config = {
  change_detection = { notify = false },
  ui = { border = globals.border }
}

-- Set lazy-lock.json to original path of config directory.
-- This is due to home manager linking from store which is read-only.
if globals.nixvars and globals.nixvars.config_dir then
  lazy_config.lockfile = globals.nixvars.config_dir .. "/lazy-lock.json"
end

require("lazy").setup(
  {
    { import = "themes.nightfox" },
    { import = "plugins" },
    { import = "lsp" }
  },
  lazy_config
)
