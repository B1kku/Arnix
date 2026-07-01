{
  pkgs-unstable,
  config,
  lib,
  ...
}:
let
  cfg = config.wayland.windowManager.hyprland;
  pluginsToHyprconf =
    plugins:
    lib.hm.generators.toHyprconf {
      attrs = {
        "exec-once" =
          let
            mkEntry =
              entry: if lib.types.package.check entry then "${entry}/lib/lib${entry.pname}.so" else entry;
          in
          map (p: "hyprctl plugin load ${mkEntry p}") cfg.plugins;
      };
    };
in
{
  wayland.windowManager.hyprland = {
    systemd.enable = false;
    # plugins = with pkgs-unstable.hyprlandPlugins; [
    #   hyprscrolling
    #   hyprfocus
    # ];
  };
  services.hypridle.enable = true;
  services.swayidle.enable = lib.mkForce false;
  xdg.configFile."hypr/hypridle.conf".source =
    config.lib.extra.mkFlakePath "/dotfiles/hypr/hypridle.conf";

  xdg.configFile."hypr/hyprland.conf".source =
    config.lib.extra.mkFlakePath "/dotfiles/hypr/hyprland.conf";
  xdg.configFile."hypr/plugins.conf".text = pluginsToHyprconf cfg.plugins;
}
