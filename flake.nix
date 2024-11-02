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
    papis = {
			url = "github:hermlon/papis/formatted-strings";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		lanzaboote = {
			url = "github:nix-community/lanzaboote/v0.4.1";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nixpkgs-zoom.url = "github:nixos/nixpkgs/a3a5586449da81401a9bf67c6fe3084a2f3cdaa0";
  };

  outputs = { nixpkgs, home-manager, lanzaboote, stylix, dune3d, papis, nixpkgs-zoom, ... }@inputs: {
    nixosConfigurations = {

      natsuki = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
				specialArgs = { inherit inputs; nixpkgs-zoom = import nixpkgs-zoom { inherit system; config.allowUnfree = true; }; };
        modules = [
          ./hosts/natsuki
					stylix.nixosModules.stylix
					lanzaboote.nixosModules.lanzaboote

          #home-manager.nixosModules.home-manager
          #{
          #  home-manager.useGlobalPkgs = true;
          #  home-manager.useUserPackages = true;
          #  home-manager.users.hermlon = import ./home;
          #  # Optionally, use home-manager.extraSpecialArgs to pass
          #  # arguments to home.nix
          #}
        ];
      };
    };
  };
}
