{
  lib,
  pkgs,
  pkgs-unstable,
  config,
  ...
}:
let
  nixvars =
    ''
      -- Code injected by Home Manager for NixOS --
    ''
    + (lib.generators.toLua { asBindings = true; } {
      "vim.g.nixvars" = {
        config_dir = "/etc/nixos/dotfiles/neovim";
        java_runtimes = {
          "17" = "${pkgs.jdk17}";
          "21" = "${pkgs.jdk21}";
        };
      };
    });
  jdtls = pkgs.writeShellScriptBin "jdtls" ''
    ${pkgs-unstable.jdt-language-server}/bin/jdtls \
    --jvm-arg=-javaagent:${pkgs-unstable.lombok}/share/java/lombok.jar
  '';
  lsps =
    (with pkgs; [
      lua-language-server
      nodePackages.pyright
      nodePackages.bash-language-server
      yaml-language-server
      gopls
      clang-tools
      rust-analyzer
      # kotlin-language-server # Too green to use, memory hog
    ])
    ++ [
      jdtls
      pkgs-unstable.nixd
    ];
  formatters = with pkgs; [
    # google-java-format
    nodePackages.prettier
  ];
  linters = with pkgs; [
    # checkstyle
    python312Packages.autopep8
  ];
  tooling = with pkgs; [
    go
    rustup
  ];
  deps = with pkgs; [
    xclip # System clipboard x11 only.
    fzf # Telescope dependency
    ripgrep # Telescope softdep
    fd # Telescope dependency?
    gcc # Treesitter fails to compile yaml otherwise.
    gnumake # Telescope fzf
    clang # Telescope softdep
  ];
  mimeTypes = [
    "text/english"
    "text/plain"
    "text/x-makefile"
    "text/x-c++hdr"
    "text/x-c++src"
    "text/x-chdr"
    "text/x-csrc"
    "text/x-java"
    "text/x-moc"
    "text/x-pascal"
    "text/x-tcl"
    "text/x-tex"
    "application/x-shellscript"
    "text/x-c"
    "text/x-c++"
  ];
in
{
  # TODO: Research remote neovim, to pipe files from yazi into neovim.
  # Home manager won't write to init.lua otherwise
  # But it's also used to inject nix specific options
  # into init.lua, in this case through extraLuaConfig.
  # If the root gets bigger I'll map these, but it's unlikely.
  xdg.configFile = {
    "nvim/lua".source = ./neovim/lua;
    "nvim/ftplugin".source = ./neovim/ftplugin;
    "nvim/init.lua".text = builtins.readFile ./neovim/init.lua;
    "nvim/nvim-remote-wrapper.sh" = {
      source = ./neovim/nvim-remote-wrapper.sh;
      executable = true;
    };
  };
  home.shellAliases = {
    nvim-test = "rm -rf ~/.config/nvim; ln -s /etc/nixos/dotfiles/neovim/ ~/.config/nvim";
    nvim-clean = "rm -rf ~/.config/nvim";
  };
  programs.neovim = {
    enable = true;
    package = pkgs-unstable.neovim-unwrapped;
    # defaultEditor = true;
    vimAlias = true;
    extraLuaConfig = nixvars;
    extraPackages = lsps ++ formatters ++ linters ++ deps ++ tooling;
  };

  home.packages =
    let
      nvim-open = pkgs.writeShellScriptBin "nvim-open" ''
        set -euo pipefail

        if [[ -f $1 ]]; then
          cd "$(dirname "$1")"
          nvim "$1"
        elif [[ -d $1 ]]; then
          cd "$1"
          nvim
        fi
      '';
    in
    [ nvim-open ];
  home.sessionVariables = {
    EDITOR = "nvim-open";
  };

  xdg.desktopEntries.nvim = {
    name = "Neovim";
    genericName = "Text Editor";
    type = "Application";
    exec = "nvim %u";
    terminal = true;
    categories = [
      "Utility"
      "TextEditor"
    ];
    icon = "nvim";
    mimeType = mimeTypes;
  };
}
