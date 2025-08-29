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
      nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";
    };
    registry = {
      nixpkgs.flake = inputs.nixpkgs-main;
      nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
    };
    channel.enable = false;
  };
  environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs-main}";
}
