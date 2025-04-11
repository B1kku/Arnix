{
  description = "Personal NixOS config.";
  inputs = {
    nixpkgs-main.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-main";
    };
    nixpkgs-old.url = "github:nixos/nixpkgs/edf04b75c13c2ac0e54df5ec5c543e300f76f1c9";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs-main";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
    };
  };
  outputs =
    {
      nixpkgs-main,
      nixpkgs-unstable,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs-main {
        inherit system;
        config.allowUnfree = true;
        overlays = [ ((import ./overlays/pkgs.nix) { inherit inputs system; }) ];
      };
      lib = pkgs.lib;
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      flake-opts = {
        # Some things just end up needing to know where the flake is.
        # Such as home manager for mkoutofstoresymlink or nvim for updating lazy.lock
        # Controls whether to link from flake-dir or flake-dir-pure.
        # Some things still need flake-dir.
        pure = false;
        flake-dir = "/etc/nixos";
        # Centralize flake inputs substituters and public keys
        # to pass to configs and tie them if the input is removed.
        extraCaches = lib.extra.getCachesFromInputs inputs {
          nix-gaming = {
            substituters = [ "https://nix-gaming.cachix.org" ];
            trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
          };
        };
      };
    in
    {
      formatter.x86_64-linux = pkgs-unstable.nixfmt-rfc-style;
      nixosConfigurations = {
        Arnix = nixpkgs-main.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              inputs
              pkgs
              pkgs-unstable
              lib
              home-manager
              flake-opts
              ;
          };
          modules = [ ./hosts/Arnix/configuration.nix ];
        };
      };
    };
}
