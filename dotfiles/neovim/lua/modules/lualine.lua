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
    -- return vim.lsp.get_active_clients({ number = vim.api.nvim_get_current_buf() })[1].name
    local buf_lsps = vim.lsp.buf_get_clients()
    if not buf_lsps then return "" end
    local display = "󰒓 "
    if not buf_lsps[1].config.root_dir then display = " " end
    display = display .. buf_lsps[1].name
    if #buf_lsps > 1 then
      display = display .. " +" .. #buf_lsps
    end
    return display
  end
}
M.lsp_progress = {
  function()
    local progress = vim.lsp.util.get_progress_messages()[1]
    return "󰒓 " .. " [" .. progress.percentage .. "%%]" .. progress.name .. ": " .. progress.title
  end
}

return M
