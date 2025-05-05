{
  config,
  pkgs,
  inputs,
  flake-opts,
  lib,
  ...
}:
{
  nix = {
    settings = {
      # Path to nixpkgs, to follow flake inputs.
      nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs-main";
    };
    registry.nixpkgs.flake = inputs.nixpkgs-main;
    channel.enable = false;
  };
  environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs-main}";
}
