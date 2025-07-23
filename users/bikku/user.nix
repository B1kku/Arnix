{
  pkgs,
  pkgs-unstable,
  inputs,
  flake-opts,
  lib,
  ...
}:
let
  username = "bikku";
in
{
  # This should take care of most game-related settings too.
  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-gamemode ];
    extraPackages = with pkgs; [
      gamescope
      mangohud
    ];
  };
  programs.gamemode.enable = true;
  programs.zsh.enable = true;
  users.users.${username} = {
    shell = pkgs.zsh;
    isNormalUser = true;
    initialPassword = "potato";
  };
  # Home Manager setup
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit pkgs-unstable inputs flake-opts;
    };
    users.${username} = {
      programs.home-manager.enable = true;
      home.username = username;
      home.homeDirectory = "/home/${username}";
      imports = [
        ./home.nix
      ];
      # Don't change randomly, used for internals.
      home.stateVersion = "23.11";
    };
  };
}
