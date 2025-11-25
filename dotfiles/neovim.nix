{
  lib,
  pkgs,
  pkgs-unstable,
  config,
  flake-opts,
  ...
}:
let
  config-dir = "/dotfiles/nvim";
  nixvars = ''
    -- Code injected by Home Manager for NixOS --
  ''
  + (lib.generators.toLua { asBindings = true; } {
    "vim.g.nixvars" = {
      config_dir = flake-opts.flake-dir + config-dir;
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

  # https://github.com/NixOS/nixpkgs/issues/337502
  lsps =
    (with pkgs; [
      lua-language-server
      pyright
      nodePackages.bash-language-server
      yaml-language-server
      gopls
      clang-tools
      rust-analyzer
      vscode-langservers-extracted
      qmlls
    ])
    ++ [
      jdtls
      pkgs-unstable.nixd
      pkgs-unstable.typescript-language-server
    ];
  formatters = with pkgs; [
    # google-java-format
    nodePackages.prettier
    shellharden
    rustfmt
    kdlfmt
  ];
  linters = with pkgs; [
    # checkstyle
    python312Packages.autopep8
  ];
  tooling = with pkgs; [
    go
    cargo
    rustc
  ];
  deps = with pkgs; [
    xclip # System clipboard x11 only.
    wl-clipboard
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
  xdg.configFile =
    let
      inherit (config.lib.extra) mkFlakePath;
    in
    {
      "nvim/lua".source = mkFlakePath (config-dir + "/lua");
      "nvim/ftplugin".source = mkFlakePath (config-dir + "/ftplugin");
      "nvim/queries".source = mkFlakePath (config-dir + "/queries");

      "nvim/init.lua".text = builtins.readFile ./nvim/init.lua;
      "nvim/nvim-remote-wrapper.sh" = {
        source = ./nvim/nvim-remote-wrapper.sh;
        executable = true;
      };
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
