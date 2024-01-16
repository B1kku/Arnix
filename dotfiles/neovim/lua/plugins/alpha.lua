return {
  "goolord/alpha-nvim",
  dependencies = {
    { 'echasnovski/mini.sessions' },
  },
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

    local function footer()
      return os.date("%A %d | %B %m")
    end
    dashboard.section.footer.val = footer()

    local restore_latest = ":lua MiniSessions.read(MiniSessions.get_latest())<CR>"

    dashboard.section.buttons.val = {
      dashboard.button("f", "󰱼  Find file", ":Telescope find_files <CR>"),
      dashboard.button("e", "󰈔  New file", ":ene <BAR> startinsert <CR>"),
      dashboard.button("r", "󰁫  Restore last session", restore_latest),
      dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
      dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
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
