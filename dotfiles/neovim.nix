{ lib, pkgs, ... }:
let
  nix-mixin = "-- Code injected by Home Manager for NixOS --\n"
    + (lib.generators.toLua {asBindings = true;} {
    "vim.g.nixvars" = {
      config_dir = "/etc/nixos";
    };
  });
in {
  # Home manager won't write to init.lua otherwise
  # But it's also used to inject nix specific options
  # into init.lua, in this case through extraLuaConfig.
  # If the root gets bigger I'll map these, but it's unlikely.
  xdg.configFile = {
    "nvim/lua" = {
      source = ./neovim/lua;
    };
    "nvim/ftplugin" = {
      source = ./neovim/ftplugin;
    };
    "nvim/init.lua" = {
      text = builtins.readFile ./neovim/init.lua;
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    # plugins = [ pkgs.vimPlugins.nvim-treesitter.withAllGrammars ];

    extraLuaConfig = nix-mixin;
    extraPackages = let
      language-server-providers = with pkgs; [
        lua-language-server
        zulu17 # Jdtls now requires java. NO, it won't once it gets merged.
        jdtls # I added lombok in there so I don't have to bother about it.
        nodePackages.pyright
      ];
    in with pkgs;
    [
      xclip # System clipboard x11 only.
      fzf # Telescope dependency
      ripgrep # Telescope softdep
      fd # Telescope dependency?
      clang # Telescope softdep
      # vector # Treesitter dep? I've seen a better way to do this somewhere...
    ] ++ language-server-providers;
  };
  xdg.desktopEntries.nvim = {
    name = "Neovim";
    genericName = "Text Editor";
    type = "Application";
    exec = "nvim %u";
    terminal = true;
    categories = [ "Utility" "TextEditor" ];
    icon = "nvim";
    mimeType = [
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
  };
}
