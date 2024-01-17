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
        jdt-language-server
        python311Packages.python-lsp-server
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
