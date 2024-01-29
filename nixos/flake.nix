{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";

    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
    
      nixosConfigurations = {
        ThinkPad = lib.nixosSystem {
          inherit system;
          # specialArgs = {inherit inputs;};
          modules = [ 
            ./configuration.nix
            ./host
            # inputs.home-manager.nixosModules.default
          ];
        };
    };
    homeConfigurations = {
      jaziel = home-manager.lib.homeManagerConfiguration { 
        inherit pkgs; 
	modules = [ ./home.nix ];	
		};  	
	};
};

}
