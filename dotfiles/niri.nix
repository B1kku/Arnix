{
  pkgs,
  pkgs-unstable,
  config,
  ...
}:
{
  xdg.configFile."niri/".source = config.lib.extra.mkFlakePath "/dotfiles/niri";
  xdg.configFile."wallust/".source = config.lib.extra.mkFlakePath "/dotfiles/wallust";
  programs.fuzzel.enable = true; # Super+D in the default setting (app launcher)
  programs.swaylock.enable = true; # Super+Alt+L in the default setting (screen locker)
  programs.waybar.enable = true; # launch on startup in the default setting (bar)
  services.mako.enable = true; # notification daemon
  services.swayidle.enable = true; # idle management daemon
  services.polkit-gnome.enable = true; # polkit
  home.packages = with pkgs; [
    pkgs-unstable.swww
    xwayland-satellite
    playerctl
  ];
}
