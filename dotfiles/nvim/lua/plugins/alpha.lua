return {
  LazyDep("echasnovski/mini.sessions"),
  {
    "goolord/alpha-nvim",
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠖⣺⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡖⠒⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠋⠀⠀⢧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢘⡆⠀⠘⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡰⠁⠀⠀⢀⡔⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢣⡀⠀⠀⠀⢳⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠇⠀⠀⢠⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢆⠀⠀⠀⢣⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⡀⠀⠀⠸⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡸⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢣⠀⠀⠀⠈⠦⣠⠤⠤⠖⠒⠒⠚⠛⠋⠙⠉⠛⠓⠒⠒⠢⠤⠤⣠⠔⠁⠀⠀⢀⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢣⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⢤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠉⠛⠲⠶⢤⣤⣄⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣤⣶⡶⠿⠛⠛⠉⠹⠀⠀⠀⢀⣠⣤⣀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣤⣄⠀⠀⢸⠀⠀⠀⠀⠀⠀⠉⠉⠙⠛⠿⠶⣶⣤⣄⡀⠀⠀⠀⠀]],
        [[⠀⠀⠀⠀⠀⠀⠀⠴⠿⠟⠋⠉⠀⠀⠀⠀⠀⠀⠀⡇⠀⢰⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣷⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠻⠷⠦⠀⠀]],
        [[⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⡯⣭⣝⡻⢽⡻⢭⡭⣍⣛⡀⠸⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⢿⣿⣿⣿⣿⡿⠀⣾⣿⣿⣿⣿⣿⡿⣿⡿⣻⡿⣿⣿⣿⠟⣿⣿⣿⣿⣿⣆]],
        [[⠀⠀⠀⠀⢠⡟⣿⡟⡏⠦⡙⣼⢽⣻⢶⡝⢶⣌⢳⣌⠣⡀⠙⢿⣿⣿⡿⠃⠀⠀⠀⠀⠘⢿⣿⣿⠟⠁⣸⣿⣿⣿⣿⣿⢋⡾⣡⢾⡏⣾⢟⣿⠏⢰⣿⢷⣿⡟⣿⣿]],
        [[⠀⠀⠀⠀⢸⡇⣿⠭⢚⣢⡧⣯⠔⣒⠨⢿⣦⢹⣧⢹⣿⡔⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣾⣿⣿⣿⣿⡿⢃⣼⠾⣫⡾⢱⣿⢸⣿⢀⣿⢿⢸⣿⡇⢸⡿]],
        [[⠀⠀⠀⠀⠸⡇⣯⣮⣤⣵⢳⠫⡑⣶⡶⢭⣿⢀⣿⣾⣿⣿⣿⣿⠋⠙⣳⣶⢶⠲⣖⠒⠺⢍⠉⢿⣿⣿⣿⣿⣯⣕⣒⣋⣥⡾⢛⣴⣟⠿⣾⡇⣸⣿⢸⡌⣿⡇⠀⠀]],
        [[⠀⠀⠀⠀⠀⡇⣿⢋⣾⡇⣾⣌⠶⣼⡼⢟⣡⣾⣿⣿⣿⣿⣿⠃⢀⠞⠀⢸⡌⢆⠘⢦⠀⠀⠳⡘⣿⣿⣿⣿⣿⣿⣿⣿⢡⣶⡻⡽⡅⠕⢸⢣⣿⣥⣾⡇⣿⡇⠀⠀]],
        [[⠀⠀⠀⠀⠀⢷⢸⢸⡿⢀⣿⢹⣿⢏⣴⠟⣩⣴⠖⣫⣽⣿⡿⡠⠁⠀⢠⠏⢳⠈⢆⠀⠳⣄⠀⠘⣿⣿⣿⡿⣿⣿⢻⣧⢸⣯⢖⡊⠛⣪⣞⡾⠅⠖⣫⣷⢸⡇⠀⠀]],
        [[⠀⠀⠀⠀⠀⢸⣼⣿⠃⣸⣿⢸⡟⣼⣣⠞⣽⢡⣾⣿⣿⣿⡇⠀⠀⡠⠋⠀⣰⢳⡈⠣⡀⠈⠣⡀⢹⣿⡿⣷⡙⢿⣇⠻⣦⠹⣷⡭⠩⣵⡏⠏⡙⡟⣞⣿⢸⣇⠀⠀]],
        [[⠀⠀⠀⠀⠀⢸⣿⡏⣰⣿⣷⢟⣵⢟⣡⣞⣡⣿⣿⣿⣿⣿⡇⡠⠜⠁⢀⠜⠁⣼⣷⣄⠙⢦⡀⠈⠪⣿⣷⣝⠛⠶⢭⣳⣌⡓⢬⡛⠿⣼⣜⣬⣑⣻⣿⣿⣼⣿⠀⠀]],
        [[⠀⠀⢀⣀⣠⣾⣿⣿⣟⣛⣛⣛⣓⣛⣛⣛⣛⣛⣛⣛⡛⠛⠋⠀⣀⠔⠁⢀⣾⣿⣿⣿⣷⣤⡉⠲⢄⣈⠛⢛⣛⣓⣲⣶⣾⣿⣷⣿⣷⣶⣾⣿⣿⣿⣿⣿⣿⣿⠀⠀]],
        [[⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠦⠤⠐⠪⠤⣤⣾⣿⣿⣿⣿⣿⣿⡏⠿⠷⣤⣌⣉⣛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀]],
        [[⣼⡿⣉⡽⠿⠻⣿⣷⣶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⢸⣿⣿⡯⠶⢹⣿⣿⡇⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠾⠿⠿⣿⡛⣿⣿⡿⠛⢻⣿⣿⠀⠀]],
        [[⢻⣿⠏⠀⠀⠀⠈⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⡇⠀⢸⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠱⣿⣿⠁⠀⠀⣿⣿⠀⠀]],
        [[⢸⣿⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⠃⠀⠸⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀⣿⣿⠀⠀]],
        [[⠻⠿⠇⠀⠀⠀⠸⢿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⡇⠀ ⠘⣿⡇⠀]],
      }

      dashboard.section.footer.val = os.date("%A %d | %B %m")

      local restore_latest = function()
        local mini_sessions = require("mini.sessions")
        mini_sessions.read(mini_sessions.get_latest())
      end

      local pick_session = function()
        local mini_sessions = require("mini.sessions").select()
      end

      dashboard.section.buttons.val = {
        dashboard.button("f", "󰱼  Find file", ":Telescope find_files <CR>"),
        dashboard.button("e", "󰈔  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", "󰁫  Restore last session", restore_latest),
        dashboard.button("s", "S  Pick session", pick_session),
        dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
        dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
        dashboard.button("l", "Lazy", "<cmd>Lazy<CR>")
      }
      dashboard.section.buttons.opts.spacing = 0

      dashboard.section.footer.opts.hl = "Type"
      dashboard.section.header.opts.hl = "Type"
      dashboard.section.buttons.opts.hl = "Include"

      dashboard.config.layout = {
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.footer,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
      }

      alpha.setup(dashboard.opts)
    end
  }
}
