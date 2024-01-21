{ lib, pkgs, ...}:

{
  home.packages = with pkgs.gnomeExtensions; [
    blur-my-shell
    gsconnect
    media-controls
    just-perfection
  ];
  # config.services.xserver.desktopManager.gnome.enable = true;
  # dconf watch / & dconf dump > ... for debugging
  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
       "blur-my-shell@aunetx"
       "gsconnect@andyholmes.github.io"
       # "just-perfection-desktop@just-perfection"
      ];
    };
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
      volume-up = [ "<Alt>KP_Up" ];
      volume-down = [ "<Alt>KP_Down" ];
      previous = [ "<Alt>KP_Left" ];
      play = [ "<Alt>KP_Begin" ];
      next = [ "<Alt>KP_Right" ];
    };
  };

}