{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/23.11";
    auto-cpufreq = {
    url = "github:AdnanHodzic/auto-cpufreq";
    inputs.nixpkgs.follows = "nixpkgs-stable";
};
#      impermanence.url = "github:nix-community/impermanence";

    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, auto-cpufreq, ... }@inputs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      overlay-unstable = final: prev: {
      #unstable = nixpkgs-unstable.legacyPackages.${prev.system};
        # use this variant if unfree packages are needed:
         unstable = import nixpkgs-unstable {
           inherit system;
           config.allowUnfree = true;
         };

      };
    in {
    
      nixosConfigurations = {
        devone = lib.nixosSystem {
          inherit system;
          # specialArgs = {inherit inputs;};
          modules = [ 
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
            ./configuration.nix
            ./host
            auto-cpufreq.nixosModules.default
            # inputs.home-manager.nixosModules.default
          ];
        };
    };
    homeConfigurations = {
      jaziel = home-manager.lib.homeManagerConfiguration { 
        inherit pkgs;
        extraSpecialArgs = { inherit overlay-unstable; };
	modules = [
	({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
	./home.nix ];
		};  	
	};
};

}
