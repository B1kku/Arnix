return {
  'stevearc/conform.nvim',
  keys = {
    { "<leader>sf", [[<cmd>lua require("conform").format({lsp_fallback = true, async = true})<CR>]], desc = "Format file" }
  },
  config = function()
    local conform = require("conform")
    -- conform.formatters["google-java-format"] = {
    --   prepend_args = { "-a" }
    -- }
    conform.formatters["nixos"] = {
      command = "nix",
      args = { "fmt", "$FILENAME" },
      stdin = false
    }
    conform.setup({
      formatters_by_ft = {
        -- java = { "google-java-format" },
        nix = { "nixos" },
        yaml = { "prettier" },
        python = { "autopep8" },
        sh = { "shellharden" }
      },
      stop_after_first = true,
    })
  end
}
