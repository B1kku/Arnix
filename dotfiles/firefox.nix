{ inputs, pkgs, ... }:
let firefox-profile = "weasel";
in {
  home.packages = [ pkgs.firefox ];

  home.file.${firefox-profile} = {
    source = ./firefox/chrome;
    target = ".mozilla/firefox/${firefox-profile}/chrome";
  };
  home.shellAliases = {
    firefox-test =
      "rm -rf ~/.mozilla/firefox/${firefox-profile}/chrome; ln -s /etc/nixos/dotfiles/firefox/chrome/ ~/.mozilla/firefox/${firefox-profile}/chrome";
    firefox-clean = "rm -rf ~/.mozilla/firefox/${firefox-profile}/chrome/";
  };
  programs.firefox = {
    enable = true;
    profiles.${firefox-profile} = {
      search.default = "DuckDuckGo";
      search.force = true;
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.toolbars.bookmarks.visibility" = "never";
        "browser.startup.page" = 3; # Restore session on startup.
        # Finally found a workaround for this stupid issue where if you drag
        # on sidebery it stops counting as :hover (gnome only, ofc)
        # https://bugzilla.mozilla.org/show_bug.cgi?id=1818517 
        "widget.gtk.ignore-bogus-leave-notify" = 1;
      };

      extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
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
