--[[ opts.lua ]]
                 --
local opt = vim.opt
local cmd = vim.api.nvim_command

vim.g.loaded_netrwPlugin = 0  -- Disable netrw

--  Context  --
-- TODO: This works, but currently breaks a bunch of things
-- telescope, which-key, etc...
-- opt.winborder = vim.g.border
opt.nuw = 1
opt.number = true         -- Show line numbers
opt.relativenumber = true -- Show relative line numbers
opt.scrolloff = 4         -- Min num lines of context
-- opt.signcolumn = "auto:1" -- Show the sign column
opt.fillchars = "eob: "   -- Hide "~" on non written lines
opt.showmode = false      -- Hide mode from bottom bar
opt.wrap = true           -- Wrap lines when they reach border
opt.breakindent = true    -- Keep indent for wrapped lines
opt.laststatus = 3        -- Make statusline global <3
opt.cmdheight = 0         -- Make cmdline dynamic
opt.conceallevel = 2    -- Allow concealed text, unless there's a replacement
opt.foldlevel = 99
opt.foldlevelstart = 99
--  Filetypes  --
opt.encoding = "utf8"     -- String encoding to use
opt.fileencoding = "utf8" -- File encoding to use

--  Search  --
opt.ignorecase = true -- Ignore case in search patterns
opt.smartcase = true  -- Override ignorecase if search contains capitals
opt.incsearch = true  -- Use incremental search
opt.hlsearch = true   -- Highlight search matches

--  Whitespace  --
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 2   -- Size of an indent
opt.softtabstop = 2  -- Number of spaces tabs count for in insert mode
opt.tabstop = 2      -- Number of spaces tabs count for

--  Splits  --
opt.splitright = true -- Place new window to right of current one
opt.splitbelow = true -- Place new window below the current one

--  Theme  --
opt.syntax = "ON"        -- Allow syntax highlighting
opt.termguicolors = true -- If term supports ui color then enable

-- Undo --
opt.undodir = vim.fn.stdpath("data") .. "/undo" --Set undo dir to nvim-data
opt.undofile = true                             -- Enable persistent undo.

-- Misc --
vim.o.clipboard = 'unnamedplus' --System clipboard integration.

-- Folding with treesitter
-- opt.foldmethod = "syntax"
-- opt.foldexpr = "nvim_treesitter#foldexpr()"
-- opt.foldlevel = 99
-- There's a bug with telescope or something, gotta reload folding or it won't work
-- vim.api.nvim_create_autocmd({ "BufEnter" }, {
--   pattern = { "*" },
--   command = "normal zx",
-- })
vim.o.sessionoptions = "curdir,folds,help,tabpages,winsize"
-- vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
-- vim.o.hidden = false
