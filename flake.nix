{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
    stylix = {
			url = "github:danth/stylix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
    dune3d = {
			url = "github:dune3d/dune3d";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		lanzaboote = {
			url = "github:nix-community/lanzaboote";
			inputs.nixpkgs.follows = "nixpkgs";
		};
  };

  outputs = { nixpkgs, home-manager, lanzaboote, stylix, dune3d, ... }@inputs: {
    nixosConfigurations = {
      natsuki = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
				specialArgs = { inherit inputs; pkgs = import nixpkgs {
					system = "x86_64-linux";
					config.allowUnfree = true;
				}; };
        modules = [
          ./hosts/natsuki
					stylix.nixosModules.stylix
					lanzaboote.nixosModules.lanzaboote

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hermlon = import ./home;
            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };
  };
}
