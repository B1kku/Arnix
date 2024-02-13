{ lib, pkgs, ... }:
let
  gnome-extensions = with pkgs.gnomeExtensions; [
    blur-my-shell
    valent
    media-controls
    just-perfection
    taskwhisperer
    alttab-mod
  ];
in {
  home.packages = with pkgs; [ valent taskwarrior ] ++ gnome-extensions;
  # home.sessionVariables = {
  #   GTK_THEME = "Adwaita:dark";
  # };
  # This should be more of a general config, tells apps what to use.
  gtk = {
    enable = true;
    font = {
      package = pkgs.noto-fonts;
      name = "NotoSans";
    };

    theme = { name = "Adwaita-dark"; };
  };
  # config.services.xserver.desktopManager.gnome.enable = true;
  # dconf watch / & dconf dump > ... for debugging
  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/shell/extensions/altTab-mod" = {
      current-monitor-only= true;
      current-workspace-only= true;
      # current-monitor-only-window = true;
      # current-workspace-only-window = true;
      remove-delay = true;
    };
    "org/gnome/shell/extensions/just-perfection" = {
      workspace-wrap-around = true;
      animation = 4;
    };
    "org/gnome/shell/extensions/blur-my-shell" = {
      hacks-level = 0;
    };
    "org/gnome/shell/extensions/blur-my-shell/overview" = {
      style-components = 3;
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions =
        map (extension: "${extension.passthru.extensionUuid}") gnome-extensions;
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
    "org/gnome/desktop/wm/keybindings" = {
      switch-to-workspace-1 = [ "<Control><Alt>1" ];
      switch-to-workspace-2 = [ "<Control><Alt>2" ];
      switch-to-workspace-3 = [ "<Control><Alt>3" ];
      switch-to-workspace-4 = [ "<Control><Alt>4" ];
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
