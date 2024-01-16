--[[ keys.lua ]]
local map = vim.keymap.set

-- Easy exit NVim
map("n", "<C-q><C-q>", [[<cmd>qa<CR>]], { silent = true, desc = "Quit Neovim" })
map("n", "qq", [[<cmd>q<CR>]], { silent = true, desc = "Quit current window" })
-- Ctrl+s saves the file on both normal and insert.
map("n", "<C-s>", [[<cmd>w<CR>]], { silent = true, desc = "Save file" })
map("i", "<C-s>", [[<cmd>w<CR><ESC><Right>]], { silent = true, desc = "Save file and go to normal" })
map("n", "<leader>sa", [[<cmd>wa<CR>]], { silent = true, desc = "Save all buffers" })
-- Remap append to insert, as I have no real use for append.
map("n", "a", "i", { silent = true })
-- Buffers
map("n", "<leader><Right>", [[<cmd>bnext<CR>]], { silent = true, desc = "Next buffer" })
map("n", "<leader><Left>", [[<cmd>bprev<CR>]], { silent = true, desc = "Previous buffer" })
-- map("n", "<leader>q", [[<cmd>b#|bd#<CR>]], {silent=true, desc = "Quit current buffer and switch to previous"})
map("n", "<leader>q", [[<cmd>bd<CR>]], { silent = true, desc = "Delete buffer" })
