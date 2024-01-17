{ config, lib, pkgs, inputs, home, ... }:

{
  programs.home-manager.enable = true;
  home.username = "bikku";
  home.homeDirectory = "/home/bikku";
  imports = [ ../../dotfiles/firefox.nix ../../dotfiles/neovim.nix ];
  programs.bash.enable = true;
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    htop
    bitwarden
    # discord
    vesktop
    # rofi
    lf
    neofetch
    peek
    fira-code-nerdfont
    prismlauncher
    steam
  ];
  # config.services.xserver.desktopManager.gnome.enable = true;
  dconf.settings = with lib.hm.gvariant; {
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
      next = [ "<Alt>KP_Right" ];
    };
  };
  # Don't change randomly, used for internals.
  home.stateVersion = "23.11";
}
