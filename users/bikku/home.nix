{ config, osConfig, lib, pkgs, pkgs-unstable, inputs, ... }: {
  programs.home-manager.enable = true;
  home.username = "bikku";
  home.homeDirectory = "/home/bikku";
  imports = [
    ../../dotfiles/colors.nix
    ../../dotfiles/games.nix
    ../../dotfiles/tmux.nix
    ../../dotfiles/yazi.nix
    ../../dotfiles/lazygit.nix
    ../../dotfiles/sshfs.nix
    ../../dotfiles/vesktop.nix
    ../../dotfiles/zsh.nix
    ../../dotfiles/wezterm.nix
    ../../dotfiles/firefox.nix
    ../../dotfiles/neovim.nix
    ../../dotfiles/gnome.nix
    ./dirs.nix
    # ../../dotfiles/alacritty.nix
  ];
  # Same case as enabling bash, let home manager add variables to it.
  xsession.enable = true;
  home.shellAliases = {
    arnix-rebuild = "sudo nixos-rebuild switch";
    arnix-update = "nix flake update /etc/nixos";
  };
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
  # No sftpman integration yet on 23.11
  # programs.sftpman
  fonts.fontconfig.enable = true;
  home.packages = (with pkgs; [
    mlocate
    rsync
    htop
    bitwarden
    fastfetch
    obs-studio
    fira-code-nerdfont
    prismlauncher
    deluge
    libnotify
    loupe # Image viewer
  ]) ++ (with pkgs.gnome; [
    baobab # Disk space info
    nautilus # File browser
    gnome-clocks # Alarms
    gnome-weather # Weather applet
    gnome-music
    gnome-calculator
    gnome-system-monitor
    gnome-tweaks
  ]);
  # Don't change randomly, used for internals.
  home.stateVersion = "23.11";
}
