{ inputs, pkgs, ... }:

{
  home.packages = [ pkgs.firefox ];

  home.file."weasel" = {
    source = ./firefox/chrome;
    target = ".mozilla/firefox/weasel/chrome";
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
}
