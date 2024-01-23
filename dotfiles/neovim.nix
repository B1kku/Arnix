{ inputs, pkgs, ... }: {
  home.file.".nvim" = {
    source = ./neovim;
    target = ".config/nvim/";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
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
    ] ++ language-server-providers;
  };

}
