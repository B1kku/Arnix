{
  config,
  osConfig,
  lib,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:
let
  # Little wrapper around nix shell, shorthand and allows specifying a branch.
  nix-shell-wrapper = pkgs.writeShellScriptBin "pkgs" ''
    nixpkgs="nixpkgs''${2:+"/nixos-$2"}"
    NIXPKGS_ALLOW_UNFREE=1 nix shell "$nixpkgs#$1" --impure
  '';
in
{
  programs.home-manager.enable = true;
  home.username = "bikku";
  home.homeDirectory = "/home/bikku";
  imports = [
    ../../dotfiles/colors.nix
    ../../dotfiles/games.nix
    ../../dotfiles/yazi.nix
    ../../dotfiles/lazygit.nix
    ../../dotfiles/vesktop.nix
    ../../dotfiles/zsh.nix
    ../../dotfiles/wezterm.nix
    ../../dotfiles/firefox.nix
    ../../dotfiles/neovim.nix
    ../../dotfiles/gnome.nix
    ./dirs.nix
    ../../modules/home-manager/lutris.nix
    # ../../dotfiles/alacritty.nix
  ];
  # Same case as enabling bash, let home manager add variables to it.
  xsession.enable = true;

  home.shellAliases = {
    arnix-rebuild = "su -c 'nixos-rebuild switch'";
    arnix-update = "nix flake update /etc/nixos";
    arnix-clean =
      let
        command = "nix-collect-garbage --delete-older-than 7d";
      in
      "su -c '${command}'; ${command}";
    neofetch = "fastfetch";
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
  # No sftpman integration yet on 23.11
  # programs.sftpman
  fonts.fontconfig.enable = true;
  home.packages =
    (with pkgs; [
      mlocate
      rsync
      rclone
      htop
      bitwarden
      fastfetch
      obs-studio
      fira-code-nerdfont # TODO: Move to a proper setting.
      prismlauncher
      deluge
      libnotify
      gthumb # Image viewer
      vlc
      protonhax
    ])
    # Gnome packages mainly
    ++ (with pkgs.gnome; [
      baobab # Disk space info
      nautilus # File browser
      gnome-clocks # Alarms
      gnome-weather # Weather applet
      gnome-music
      gnome-calculator
      gnome-system-monitor
      gnome-tweaks
    ])
    ++ [ nix-shell-wrapper ];
  # Don't change randomly, used for internals.
  home.stateVersion = "23.11";
}
