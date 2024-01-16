{
  description = "Personal NixOS config.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in {
      formatter.x86_64-linux = pkgs.nixfmt;
      nixosConfigurations = {
        Arnix = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit pkgs inputs home-manager; };
          modules = [ ./system/Arnix/configuration.nix ];
        };
      };
    };
}
