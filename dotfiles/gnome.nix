{ lib, pkgs, pkgs-unstable, config, inputs, ... }:
let
  # gtkThemeFromScheme = (inputs.nix-colors.lib-contrib {inherit pkgs;}).gtkThemeFromScheme;
  gnome-extensions = (with pkgs.gnomeExtensions; [
    blur-my-shell
    # https://github.com/NixOS/nixpkgs/issues/301380
    # pkgs-unstable.gnomeExtensions.valent
    media-controls
    just-perfection
    # taskwhisperer # TODO: 24.05 BORKED !!
    alttab-mod
    switch-workspace
    color-picker
    quick-settings-audio-panel
    smart-auto-move
  ]);
in {
  home.packages = gnome-extensions;
  /* ++ (with pkgs;
     [ # pkgs-unstable.valent
       # taskwarrior
       # gnome.pomodoro
     ]);
  */
  # This should be more of a general config, tells apps what to use.
  gtk = {
    enable = true;
    # theme = {
    #   name = "${config.colorScheme.slug}";
    #   package = gtkThemeFromScheme {scheme = config.colorScheme;};
    # };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
  };
  # dconf watch / & dconf dump > ... for debugging
  dconf.settings = let inherit (lib.hm.gvariant) mkUint32;
  in {
    "org/gnome/shell/extensions/switchWorkSpace".switch-workspace =
      [ "<Super>Tab" ];
    "org/gnome/shell/extensions/altTab-mod" = {
      current-monitor-only = true;
      current-workspace-only = true;
      # current-monitor-only-window = true;
      # current-workspace-only-window = true;
      remove-delay = true;
    };
    "org/gnome/shell/extensions/mediacontrols" = {
      show-label = false;
      show-control-icons-seek-forward = false;
      show-control-icons-seek-backward = false;
      extension-position = "Left";
      extension-index = mkUint32 1;
    };
    "org/gnome/shell/extensions/smart-auto-move" = {
      sync-frequency = 5000;
      save-frequency = 5000;
    };
    "org/gnome/shell/extensions/just-perfection" = {
      workspace-wrap-around = true;
      animation = 4;
    };
    "org/gnome/shell/extensions/blur-my-shell" = { hacks-level = 0; };
    "org/gnome/shell/extensions/blur-my-shell/overview".style-components = 3;
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions =
        map (extension: "${extension.passthru.extensionUuid}") gnome-extensions;
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = true;
    };
    "org/gnome/desktop/peripherals/mouse".accel-profile = "flat";
    "org/gnome/mutter" = {
      edge-tiling = true;
      dynamic-workspaces = false;
      workspaces-only-on-primary = false;
    };
    "org/gnome/desktop/wm/preferences" = { num-workspaces = 4; };
    "org/gnome/shell/app-switcher".current-workspace-only = true;
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-temperature = mkUint32 3700;
    };
    "org/gnome/desktop/wm/keybindings" = {
      # switch-to-workspace-rigth = [ "<Super><Shift>Tab" ];
      # switch-to-workspace-left = [ "<Super>Tab" ];
      switch-applications = [ "<Alt>Tab" ];
      switch-to-workspace-1 = [ "<Alt>1" ];
      switch-to-workspace-2 = [ "<Alt>2" ];
      switch-to-workspace-3 = [ "<Alt>3" ];
      switch-to-workspace-4 = [ "<Alt>4" ];
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
