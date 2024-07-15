return {
  "nvim-neorg/neorg",
  version = "*",
  config = function()
    require("neorg").setup {
      load = {
        ["core.defaults"] = {},
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp"
          }
        },
        ["core.concealer"] = {
          config = {
            folds = true
          },
          init_open_folds = "auto"
        },
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/.Notes",
              opsidian = "~/OPsidian",
            },
            default_workspace = "notes",
          },
        },
      },
    }
  end
}
