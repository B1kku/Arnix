local M = {}

M.active_register = {
  function()
    if vim.fn.reg_recording() ~= "" then
      return " " .. vim.fn.reg_recording():upper()
    else
      return ""
    end
  end
}
M.center_component = {
  function()
    return "%="
  end,
  separator = ""
}
M.lsp_name = {
  function()
    local buf_lsps = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
    if not buf_lsps then return "" end
    local display = "󰒓 "
    if not buf_lsps[1].config.root_dir then display = " " end
    display = display .. buf_lsps[1].name
    if #buf_lsps > 1 then
      display = "+" .. (#buf_lsps - 1) .. " " .. display
    end
    return display
  end
}
M.lsp_progress = {
  function()
    -- TODO: Properly implement this    
    -- local x = vim.lsp.get_clients()[1].progress
    -- local iter = vim.iter(x)
    -- if not vim.tbl_isempty(x.pending) then
    --   vim.notify(vim.inspect(iter:next()))
    -- end
    return ""
    -- local progress = vim.lsp.get_clients()[1]
    -- return "󰒓 " .. " [" .. progress.percentage .. "%%]" .. progress.name .. ": " .. progress.title
  end
}

return M
