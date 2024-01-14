{ config, pkgs, inputs, ... }:

{
  programs.home-manager.enable = true;
  home.username = "bikku";
  home.homeDirectory = "/home/bikku";
  home.file = {
    "weasel" = { # Firefox dotfiles
      source = ./dotfiles/firefox/chrome;
      target = ".mozilla/firefox/weasel/chrome";
    };
    ".nvim" = {
      source = ./dotfiles/nvim;
      target = ".config/nvim/";
    };
  };
  home.packages = with pkgs; [
    htop
    firefox
    bitwarden
    discord
    rofi
    tree
    glibc
    peek
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = let
      language-server-providers = with pkgs; [
        lua-language-server
        python311Packages.python-lsp-server
      ];
    in with pkgs;
    [
      xclip # System clipboard
      fzf # Telescope dependency
      ripgrep # Telescope softdep
      fd # Telescope dependency?
      clang # Telescope softdep
    ] ++ language-server-providers;
  };
  programs.firefox = {
    enable = true;
    profiles.weasel = {
      search.default = "DuckDuckGo";
      search.force = true;
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.toolbars.bookmarks.visibility" = "never";
        "browser.startup.page" = 3; # Restore session on startup.
      };

      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        ublock-origin
        sidebery
        behave
        skip-redirect
        forget_me_not
        firefox-translations
        darkreader
        #	betterttv
        #	return-youtube-dislikes
      ];
    };
  };
  # Don't change randomly, used for internals.
  home.stateVersion = "23.11";
}
