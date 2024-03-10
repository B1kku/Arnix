return {
  'stevearc/overseer.nvim',
  keys = {
    { "<leader><cr>", [[<cmd>OverseerToggle<CR>]],        "n", silent = true, desc = "Toggle Overseer Tasks" },
    { "<C-CR>",       [[<cmd>lua OverseerRestart()<CR>]], "n", silent = true, desc = "Restart last task, or choose a template" }
  },
  config = function()
    local overseer = require('overseer')
    function OverseerRestart()
      local tasks = overseer.list_tasks({ recent_first = true })
      if vim.tbl_isempty(tasks) then
        vim.cmd("OverseerRun")
      else
        if (tasks[1].status == "PENDING") then
          overseer.run_action(tasks[1], "start")
        elseif (tasks[1].status ~= "RUNNING") then
          overseer.run_action(tasks[1], "restart")
        end
      end
    end

    vim.o.exrc = true
    local win_opts = {
      winblend = 0,
    }
    overseer.setup({
      bundles = {
        autostart_on_load = false
      },
      templates = { "builtin", "java.maven", "java.gradle", "deploy.rsync", "wrapper" },
      task_list = {
        direction = "bottom",
        bindings = {
          ["a"] = "<CMD>OverseerRun<CR>"
        }
      },
      form = {
        win_opts = win_opts
      },
      confirm = {
        win_opts = win_opts
      },
      task_win = {
        win_opts = win_opts
      }
    })
  end,
}
