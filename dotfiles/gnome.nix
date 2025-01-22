{
  lib,
  pkgs,
  pkgs-unstable,
  config,
  inputs,
  ...
}:
let
  # Variables to modify the gnome config
  # For things that often need changing, besides dconf specifics.
  icon-theme = {
    package = pkgs.papirus-icon-theme;
    name = "Papirus-Dark";
  };
  minutes-to-suspend = 5;
  minutes-to-turn-off-screen = 3;
  gnome-extensions = (
    with pkgs.gnomeExtensions;
    [
      blur-my-shell
      just-perfection
      alttab-mod
      switch-workspace
      color-picker
      quick-settings-audio-panel
      auto-move-windows
      gsconnect
      tracker
      gamemode-shell-extension
    ]
  );
  num-workspaces = 4;
  workspace-actions = {
    move-to-workspace = "<Ctrl><Alt>";
    switch-to-workspace = "<Alt>";
  };

  # Generate keybinds for an ammount of workspaces.
  # Keybinds will use the base + n.
  # switch-to-workspace-1 = [ <alt>1 ]
  # Might not even be worth to use this...
  generateWorkspaceKeybinds = (
    workspaces: workspace-actions:
    let
      inherit (lib)
        range
        concatMapAttrs
        fold
        mergeAttrs
        ;
      mapWorkspace = (workspace: action: key: { "${action}-${workspace}" = [ "${key}${workspace}" ]; });
    in
    workspaces
    |> range 1
    |> fold (
      workspace: acc:
      let
        mapAction = workspace |> toString |> mapWorkspace;
      in
      workspace-actions |> concatMapAttrs mapAction |> mergeAttrs acc
    ) { }
  );
in
{
  home.packages = gnome-extensions;
  # This should be more of a general config, tells apps what to use.
  qt = {
    enable = true;
    style.name = "adwaita-dark";
  };

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    gtk.enable = true;
    size = 24;
  };
  # Icon theme generation.
  home.file = {
    ${icon-theme.name} = {
      source = "${icon-theme.package}/share/icons/${icon-theme.name}";
      target = ".icons/${icon-theme.name}";
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };
  # dconf watch / & dconf dump > ... for debugging
  dconf.settings =
    let
      inherit (lib.hm.gvariant) mkUint32;
    in
    {
      "org/gnome/shell/extensions/gamemodeshellextension" = {
        show-icon-only-when-active = true;
        show-launch-notification = false;
      };
      "org/gnome/shell/extensions/quick-settings-audio-panel" = {
        move-master-volume = false;
        merge-panel = true;
        media-controls = "none";
      };
      "org/gnome/shell/extensions/switchWorkSpace".switch-workspace = [ "<Super>Tab" ];
      "org/gnome/shell/extensions/altTab-mod" = {
        current-monitor-only = true;
        current-workspace-only = true;
        remove-delay = true;
      };
      "org/gnome/shell/extensions/just-perfection" = {
        workspace-wrap-around = true;
        animation = 4;
      };
      # Transparent dock bar on overview
      "org/gnome/shell/extensions/blur-my-shell/overview".style-components = 3;
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = map (extension: "${extension.passthru.extensionUuid}") gnome-extensions;
      };
      "org/gnome/desktop/interface" = {
        icon-theme = icon-theme.name;
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
        button-layout = "icon:close";
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
      "org/gnome/desktop/wm/keybindings" = {
        switch-applications = [ "<Alt>Tab" ];
      } // (generateWorkspaceKeybinds num-workspaces workspace-actions);
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
