{
  inputs,
  pkgs,
  pkgs-unstable,
  ...
}: let
  firefox-profile = "weasel";
  extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
    ublock-origin
    sidebery
    behave
    skip-redirect
    forget_me_not
    firefox-translations
    darkreader
    seventv
    return-youtube-dislikes
  ];
  maskFree = (
    pkg:
      if !pkg.meta.unfree
      then pkg
      else
        pkg.overrideAttrs (attrs: {
          meta =
            attrs.meta
            or {}
            // {
              license =
                attrs.meta.license
                // {
                  free = true;
                };
            };
        })
  );
in {
  home.file.${firefox-profile} = {
    source = ./firefox/chrome;
    target = ".mozilla/firefox/${firefox-profile}/chrome";
  };
  home.shellAliases = {
    firefox-test = "rm -rf ~/.mozilla/firefox/${firefox-profile}/chrome; ln -s /etc/nixos/dotfiles/firefox/chrome/ ~/.mozilla/firefox/${firefox-profile}/chrome";
    firefox-clean = "rm -rf ~/.mozilla/firefox/${firefox-profile}/chrome";
  };
  programs.firefox = {
    enable = true;
    package = pkgs-unstable.firefox;
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
      extensions = map maskFree extensions;
    };
  };
}
