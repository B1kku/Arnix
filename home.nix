{ config, pkgs, inputs, ... }:

{
  programs.home-manager.enable = true;
  home.username = "bikku";
  home.homeDirectory = "/home/bikku";
  home.file = {
    "weasel" = {
      source = ./dotfiles/firefox/chrome;
      target = ".mozilla/firefox/weasel/chrome";
    };

  };
  home.packages = with pkgs; [ htop firefox bitwarden discord rofi tree ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [ xclip fzf fd ];
  };
  programs.firefox = {
    enable = true;
    profiles.weasel = {
      search.default = "DuckDuckGo";
      search.force = true;
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.toolbars.bookmarks.visibility" = "never";
	"browser.startup.page" = 3;
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
