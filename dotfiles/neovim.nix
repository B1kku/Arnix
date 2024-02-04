{ inputs, pkgs, ... }:

{
  home.file.".nvim" = {
    source = ./neovim;
    target = ".config/nvim/";
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
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
