return {
  name = "Rclone copy",
  desc = "Move a glob to another directory",
  builder = function(params)
    -- Always dry run at first
    local args = { "--dry-run" }
    if params.filter_file then
      vim.list_extend(args, { "--filter-from", params.filter_file })
    end
    if params.backup_remote then
      local backup_remote = { "--backup-dir", params.backup_remote .. ":./.rclone_cache" }
      if params.backup_remote == "none" then
        backup_remote = { "--inplace" }
      end
      vim.list_extend(args, backup_remote)
    end
    if params.extra then
      vim.list_extend(args, params.extra)
    end

    table.insert(args, params.from)
    table.insert(args, params.to)

    return {
      name = "Rclone copy " .. params.to,
      cmd = { "rclone", "copy" },
      args = args,
      components = { "default" }
    }
  end,
  params = {
    from = {
      type = "string",
      order = 1
    },
    to = {
      type = "string",
      order = 2
    },
    filter_file = {
      type = "string",
      optional = true,
      order = 3
    },
    backup_remote = {
      type = "string",
      default = "none",
      optional = true,
      order = 4
    },
    extra = {
      type = "list",
      subtype = {
        type = "string"
      },
      delimiter = ",",
      optional = true,
      order = 5
    },
  }
}
