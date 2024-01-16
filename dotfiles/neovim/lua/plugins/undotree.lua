return {
  -- Keeps undos as a tree allowing you to branch and such --
  "mbbill/undotree",
  keys = {
    { "<leader>u", [[<CMD>UndotreeToggle<CR>]], "n", silent = true, desc = "Undo history." }
  }
}
