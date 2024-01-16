-- Fix indents on lua to 2, even though convention is 4.
local bopt = vim.bo
bopt.expandtab = true -- Use spaces instead of tabs
bopt.shiftwidth = 2   -- Size of an indent
bopt.softtabstop = 2  -- Number of spaces tabs count for in insert mode
bopt.tabstop = 2      -- Number of spaces tabs count for
