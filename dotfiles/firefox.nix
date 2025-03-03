{
  inputs,
  pkgs,
  config,
  pkgs-unstable,
  flake-opts,
  ...
}:
let
  firefox-profile = "weasel";
  extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
    ublock-origin
    sidebery
    darkreader
    seventv
  ];
  maskFree = (
    pkg:
    if !pkg.meta.unfree then
      pkg
    else
      pkg.overrideAttrs (attrs: {
        meta = attrs.meta or { } // {
          license = attrs.meta.license // {
            free = true;
          };
        };
      })
  );
  flake-dir = flake-opts.flake-dir;
in
{
  home.file.${firefox-profile} = {
    source = config.lib.extra.mkFlakePath "/dotfiles/firefox/chrome";
    target = ".librewolf/${firefox-profile}/chrome";
  };
  programs.librewolf = {
    enable = true;
    # package = pkgs-unstable.librewolf;
    profiles.${firefox-profile} = {
      search.default = "DuckDuckGo";
      search.force = true;
      settings =
        let
          # List of RFP Targets
          # https://searchfox.org/mozilla-central/source/toolkit/components/resistfingerprinting/RFPTargets.inc
          RFPTargets = [
            # Enable all RFP, any further "-Target" will be excluded
            "+AllTargets"
            # Re-enable prefers dark mode
            # idk the consequences, but darkreader aint cutting it
            # Also I don't feel whitelisting random website cookies for dark theme is better
            "-CSSPrefersColorScheme"
            "-RoundWindowSize" # Don't forget window size on reopen
          ];
        in
        {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.toolbars.bookmarks.visibility" = "never";
          "browser.startup.page" = 3; # Restore session on startup.
          "general.autoScroll" = true; # Enable middle click to free scroll.
          "devtools.debugger.remote-enabled" = false; # Enable to debug CSS with <C-S-M>i
          # Finally found a workaround for this stupid issue where if you drag
          # on sidebery it stops counting as :hover (gnome only, ofc)
          # https://bugzilla.mozilla.org/show_bug.cgi?id=1818517
          "widget.gtk.ignore-bogus-leave-notify" = 1;
          "privacy.resistFingerprinting" = false;
          "privacy.fingerprintingProtection" = true;
          "privacy.fingerprintingProtection.overrides" = builtins.concatStringsSep "," RFPTargets;

        };
      extensions = map maskFree extensions;
    };
  };
}
