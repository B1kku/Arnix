return {
  'stevearc/overseer.nvim',
  keys = {
    { "<leader><cr>", [[<cmd>OverseerToggle<CR>]],        "n", silent = true, desc = "Toggle Overseer Tasks" },
    { "<C-CR>",       [[<cmd>lua OverseerRestart()<CR>]], "n", silent = true, desc = "Restart last task, or choose a template" }
  },
  config = function()
    local overseer = require('overseer')
    local STATUS = require("overseer.constants").STATUS
    -- TODO: There's currently a bug where if a child task fails this won't restart it
    local run_task = function(task)
      if (task.status == STATUS.PENDING) then
        overseer.run_action(task, "start")
      elseif (task.status ~= STATUS.RUNNING) then
        overseer.run_action(task, "restart")
      end
    end
    -- Wish there was a way to get the task passed, or at least be able to add
    -- new sidebar mappings, but seems hardcoded for now.
    local function sidebar_run_action(action)
      return function()
        local sidebar_module = require("overseer.task_list.sidebar")
        local sidebar = sidebar_module.get()
        if sidebar == nil then
          return
        end
        sidebar:run_action(action)
      end
    end

    function OverseerRestart()
      local tasks = overseer.list_tasks({ recent_first = true })
      if vim.tbl_isempty(tasks) then
        vim.cmd("OverseerRun")
      else
        run_task(tasks[1])
      end
    end

    local win_opts = {
      winblend = 0,
    }
    overseer.setup({
      bundles = {
        autostart_on_load = false
      },
      templates = { "builtin", "java.maven", "java.gradle", "go.run", "go.build", "c.gcc", "deploy.rsync", "deploy.rclone_copy", "deploy.rclone_mount", "wrapper" },
      actions = {
        ["run"] = {
          desc = "Just run the task... Don't care if I have to restart or start.",
          run = run_task
        }
      },
      task_list = {
        direction = "bottom",
        bindings = {
          ["a"] = "<CMD>OverseerRun<CR>",
          ["e"] = "Edit",
          ["f"] = "OpenFloat",
          ["r"] = sidebar_run_action("run")
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
  end
}
