{ lib, pkgs, pkgs-unstable, config, ... }:
let
  # TODO: Figure out why this breaks 
  # https://github.com/NixOS/nixpkgs/commit/ebbd613587758567d62555cfe91a770148e1a30f
  jdtls = pkgs.writeShellScriptBin "jdtls" ''
    ${pkgs.jdt-language-server}/bin/jdtls \
    --jvm-arg=-javaagent:${pkgs-unstable.lombok}/share/java/lombok.jar
  '';
  nixvars = ''
    -- Code injected by Home Manager for NixOS --
  '' + (lib.generators.toLua { asBindings = true; } {
    "vim.g.nixvars" = {
      config_dir = "/etc/nixos/dotfiles/neovim";
      java_runtimes = {
        "17" = "${pkgs.jdk17}";
        "21" = "${pkgs.jdk21}";
      };
    };
  });
  lsps = (with pkgs; [
    lua-language-server
    kotlin-language-server
    nodePackages.pyright
    nodePackages.bash-language-server
    yaml-language-server
    gopls
    go
    clang-tools
    nixd
  ]) ++ [ jdtls ];
  formatters = with pkgs; [ google-java-format nodePackages.prettier ];
  linters = with pkgs;
    [
      # checkstyle
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
in {
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
    nvim-test =
      "rm -rf ~/.config/nvim; ln -s /etc/nixos/dotfiles/neovim/ ~/.config/nvim";
    nvim-clean = "rm -rf ~/.config/nvim";
  };
  programs.neovim = {
    enable = true;
    package = pkgs-unstable.neovim-unwrapped;
    defaultEditor = true;
    vimAlias = true;
    extraLuaConfig = nixvars;
    extraPackages = lsps ++ formatters ++ linters ++ deps;
  };

  xdg.desktopEntries.nvim = {
    name = "Neovim";
    genericName = "Text Editor";
    type = "Application";
    exec = "nvim %u";
    terminal = true;
    categories = [ "Utility" "TextEditor" ];
    icon = "nvim";
    mimeType = mimeTypes;
  };
}
