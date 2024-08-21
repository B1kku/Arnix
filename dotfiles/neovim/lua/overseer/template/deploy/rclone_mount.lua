return {
  name = "Rclone mount remote",
  desc = "Mount a remote on a given directory",
  builder = function(params)
    -- Always dry run at first
    local args = { "--read-only" }
    if params.max_cache_size then
      local extra_args = { "--vfs-cache-mode", "full", "--vfs-cache-max-size", params.max_cache_size }
      vim.list_extend(args, extra_args)
    end
    if params.filter_file then
      vim.list_extend(args, { "--filter-from", params.filter_file })
    end
    if params.backup_remote then
      local backup_remote = { "--backup-dir", params.backup_remote .. ":./.rclone_cache" }
      vim.list_extend(args, backup_remote)
    end
    if params.extra then
      vim.list_extend(args, params.extra)
    end

    table.insert(args, params.remotedir )
    table.insert(args, params.mountdir)

    return {
      name = "Rclone mount " .. params.remotedir,
      cmd = { "rclone", "mount" },
      args = args,
      components = { "default" }
    }
  end,
  params = {
    remotedir = {
      type = "string",
      order = 1
    },
    mountdir = {
      type = "string",
      order = 2
    },
    max_cache_size = {
      type = "string",
      optional = true,
      order = 3
    },
    filter_file = {
      type = "string",
      optional = true,
      order = 4
    },
    backup_remote = {
      type = "string",
      optional = true,
      order = 5
    },
    extra = {
      type = "list",
      subtype = {
        type = "string"
      },
      delimiter = ",",
      optional = true,
      order = 6
    },
  }
}
