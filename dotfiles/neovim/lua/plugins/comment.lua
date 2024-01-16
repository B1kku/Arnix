return {
  -- Plugin for comment keymaps mainly --
  "numToStr/Comment.nvim",
  config = function()
    require("Comment").setup({
      mappings = {
        basic = false,
        extra = false
      }
    })
    local map = vim.keymap.set
    map("n", "<leader>cl", function()
      return vim.v.count == 0
          and "<Plug>(comment_toggle_linewise_current)"
          or "<Plug>(comment_toggle_linewise_count)"
    end, { expr = true, silent = true, desc = "Comment line or n lines" })
    map("n", "<leader>cm", function()
      return vim.v.count == 0
          and "<Plug>(comment_toggle_blockwise_current)"
          or "<Plug>(comment_toggle_blockwise_count)"
    end, { expr = true, silent = true, desc = "Comment block or n lines as block" })
    map("v", "<leader>cm", "<Plug>(comment_toggle_blockwise_visual)", { silent = true, desc = "Comment block" })
    map("v", "<leader>cl", "<Plug>(comment_toggle_linewise_visual)", { silent = true, desc = "Comment line" })
  end
}
