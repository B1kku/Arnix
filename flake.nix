{
	description = "A very basic flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
		home-manager = {
			url = "github:nix-community/home-manager/release-23.11";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, home-manager }:
		let
		system = "x86_64-linux";
	pkgs = import nixpkgs {
		inherit system;
		config.allowUnfree = true;
	};
	lib = nixpkgs.lib;
	in {
		nixosConfigurations = {
			bikku = lib.nixosSystem {
				inherit system;
				modules = [ ./configuration.nix ];
			};
		};
		homeConfigurations = {
			bikku = home-manager.lib.homeManagerConfiguration {
				pkgs = pkgs;
				modules = [
				{
					home = {
						username = "bikku";
						homeDirectory = "/home/bikku";
						stateVersion = "23.11";
					};
				}
				];
#          inherit system.pkgs;
#          username = "bikku";
#          homeDirectory = "/home/bikku";
#          configuration = {
#           imports = [    ]
#           };
			};
		};
	};
}
