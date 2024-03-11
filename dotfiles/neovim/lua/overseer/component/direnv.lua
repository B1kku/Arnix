return {
  desc = "Make sure to use direnv for task.",
  constructor = function(params)
    return {
      original_cmd = nil,
      wrapped_cmd = nil,
      on_init = function(self, task)
        local has_direnv = vim.fs.find({ ".direnv" }, { upward = true })[1]
        if not has_direnv then
          self.on_pre_start = function() end;
          self.on_pre_result = function() end;
          return;
        end

        self.original_cmd = task.cmd
        if type(task.cmd) == "string" then
          self.wrapped_cmd = "direnv exec" .. " " .. task.cwd .. " " .. task.cmd
          return;
        end
        self.wrapped_cmd = { "direnv", "exec", task.cwd }
        vim.list_extend(self.wrapped_cmd, task.cmd)
      end,

      on_pre_start = function(self, task)
        task.cmd = self.wrapped_cmd
      end,

      on_pre_result = function(self, task)
        task.cmd = self.original_cmd
      end
    }
  end
}
