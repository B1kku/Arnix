{ config, lib, pkgs, inputs, ... }:

{
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
  programs.home-manager.enable = true;
  programs.bash.enable = true;
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    htop
    firefox
    bitwarden
    # discord
    vesktop
    # rofi
    lf
    neofetch
    peek
    fira-code-nerdfont
    prismlauncher
  ];

  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = true;
    };
    "org/gnome/mutter" = {
      edge-tiling = true;
      dynamic-workspaces = false;
      workspaces-only-on-primary = false;
    };
    "org/gnome/desktop/wm/preferences" = { num-workspaces = 4; };
    "org/gnome/shell/app-switcher" = { current-workspace-only = false; };
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-temperature = mkUint32 3700;
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      mic-mute = [ "<Alt>z" ];
      next = [ "<Alt>KP_Right" ];
    };
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
