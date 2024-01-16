-- Add .gradle as a java filetype to have jdtls and be able to reload config within.
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*.gradle",
  command = "setfiletype java"
})
