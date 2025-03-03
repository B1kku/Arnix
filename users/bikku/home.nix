{
  config,
  osConfig,
  lib,
  pkgs,
  pkgs-unstable,
  flake-opts,
  inputs,
  ...
}:
let
  # Little wrapper around nix shell, shorthand and allows specifying a branch.
  nix-shell-wrapper = pkgs.writeShellScriptBin "pkgs" ''
    nixpkgs="nixpkgs''${2:+"/nixos-$2"}"
    NIXPKGS_ALLOW_UNFREE=1 nix shell "$nixpkgs#$1" --impure
  '';
  flake-dir = flake-opts.flake-dir;
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
  lib = {
    extra = {
      mkFlakePath =
        if flake-opts.pure then
          (path: inputs.self + path)
        else
          (path: config.lib.file.mkOutOfStoreSymlink (flake-opts.flake-dir + path));
    };
  };
  # Same case as enabling bash, let home manager add variables to it.
  xsession.enable = true;

  home.shellAliases =
    let
      buildNHCommand = (_: command: "pkexec ${command}");
      nixos-aliases =
        {
          arnix-rebuild = "nh os switch ${flake-dir} -R";
          arnix-update = "nh os switch ${flake-dir} -u -R";
          arnix-clean = "nh clean all --keep-since 7d --keep 5 --ask";
        }
        |> builtins.mapAttrs buildNHCommand;
    in
    {
      neofetch = "fastfetch";
    }
    // nixos-aliases;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    stdlib = builtins.readFile ../../dotfiles/direnvrc;
  };
  fonts.fontconfig.enable = true;
  home.packages =
    (with pkgs; [
      mlocate
      rsync
      rclone
      btop-rocm
      bitwarden
      fastfetch
      fira-code-nerdfont # TODO: Move to a proper setting.
      prismlauncher
      deluge
      libnotify
      gthumb # Image viewer
      vlc
      nh
    ])
    # Gnome packages mainly
    # TODO: Move these to gnome.nix?
    ++ (with pkgs; [
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

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [ obs-pipewire-audio-capture ];
  };
  # Don't change randomly, used for internals.
  home.stateVersion = "23.11";
}
