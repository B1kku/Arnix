return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "jay-babu/mason-nvim-dap.nvim",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-telescope/telescope-dap.nvim"
    },
    config = function()
      require("dapui").setup()
      vim.keymap.set("n", "<leader>dk", ":lua require('dap').continue()<CR>")
      vim.keymap.set("n", "<leader>dl", ":lua require('dap').run_last()<CR>")
      -- vim.keymap.set("n", "<leader>b", ":lua require('dap').toggle_breakpoint()<CR>")
    end
  },
  {
    --Python dap plugin
    "mfussenegger/nvim-dap-python",
    config = function()
      local path = require("mason-registry").get_package("debugpy"):get_install_path()
      require("dap-python").setup(path .. "/venv/Scripts/python")
    end
  }
}
