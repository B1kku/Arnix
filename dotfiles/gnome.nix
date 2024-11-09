{
  lib,
  pkgs,
  pkgs-unstable,
  config,
  inputs,
  ...
}: let
  # gtkThemeFromScheme = (inputs.nix-colors.lib-contrib {inherit pkgs;}).gtkThemeFromScheme;
  minutes-to-suspend = 5;
  minutes-to-turn-off-screen = 3;
  gnome-extensions = (
    with pkgs.gnomeExtensions; [
      blur-my-shell
      # https://github.com/NixOS/nixpkgs/issues/301380
      # pkgs-unstable.gnomeExtensions.valent
      media-controls
      just-perfection
      alttab-mod
      switch-workspace
      color-picker
      quick-settings-audio-panel
      auto-move-windows
    ]
  );
  num-workspaces = 4;
  workspace-actions = {
    move-to-workspace = "<Ctrl><Alt>";
    switch-to-workspace = "<Alt>";
  };
  generateWorkspaceKeybinds = (
    workspaces: workspace-actions: let
      inherit (lib) range listToAttrs concatMapAttrs;
      mapAction = (
        action: key:
          listToAttrs (
            map (
              n: let
                workspace = toString n;
              in {
                name = "${action}-${workspace}";
                value = ["${key + workspace}"];
              }
            ) (range 1 workspaces)
          )
      );
    in
      concatMapAttrs mapAction workspace-actions
  );
in {
  home.packages = gnome-extensions;
  # This should be more of a general config, tells apps what to use.
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
  };
  # dconf watch / & dconf dump > ... for debugging
  dconf.settings = let
    inherit (lib.hm.gvariant) mkUint32;
  in {
    "org/gnome/shell/extensions/switchWorkSpace".switch-workspace = ["<Super>Tab"];
    "org/gnome/shell/extensions/altTab-mod" = {
      current-monitor-only = true;
      current-workspace-only = true;
      remove-delay = true;
    };
    "org/gnome/shell/extensions/mediacontrols" = {
      show-label = false;
      show-control-icons-seek-forward = false;
      show-control-icons-seek-backward = false;
      extension-position = "Left";
      extension-index = mkUint32 1;
    };
    "org/gnome/shell/extensions/just-perfection" = {
      workspace-wrap-around = true;
      animation = 4;
    };
    "org/gnome/shell/extensions/blur-my-shell" = {
      hacks-level = 0;
    };
    "org/gnome/shell/extensions/blur-my-shell/overview".style-components = 3;
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = map (extension: "${extension.passthru.extensionUuid}") gnome-extensions;
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
    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = num-workspaces;
    };
    "org/gnome/shell/app-switcher".current-workspace-only = true;
    "org/gnome/desktop/session".idle-delay = mkUint32 (minutes-to-turn-off-screen * 60);
    "org/gnome/settings-daemon/plugins/power".sleep-inactive-ac-timeout = mkUint32 (
      minutes-to-suspend * 60
    );
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-temperature = mkUint32 3700;
    };
    "org/gnome/desktop/wm/keybindings" =
      {
        switch-applications = ["<Alt>Tab"];
      }
      // (generateWorkspaceKeybinds num-workspaces workspace-actions);
    "org/gnome/settings-daemon/plugins/media-keys" = {
      mic-mute = ["<Alt>z"];
      volume-up = ["<Alt>KP_Up"];
      volume-down = ["<Alt>KP_Down"];
      previous = ["<Alt>KP_Left"];
      play = ["<Alt>KP_Begin"];
      next = ["<Alt>KP_Right"];
    };
  };
}
