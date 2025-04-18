{
  description = "Nixos config flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "git+https://github.com/NixOS/nixpkgs?shallow=1&ref=nixos-unstable";

# nixos config things

    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };


# Home-manager things
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixCats = {
      url = "git+file:///home/friday/nix-inputs/nixCats/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+file:///home/friday/nix-inputs/quickshell/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    kickstart = {
      url = "git+file:///home/friday/.config/kickstart/";
      inputs.nixpkgs.follows = "nixpkgs";
    };



  };

  outputs = { self, nixpkgs, auto-cpufreq, home-manager, ... }@inputs: 
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    localbuilds = {
      snitch = import ./packages/snitch.nix { inherit nixpkgs; };
    };
    # pkgs = import nixpkgs {
    #   inherit system;
    #   config = {
    #     # allowUnfree = true;
    #   };
    # };
  in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit system inputs;};
      modules = [
        ./nixos/configuration.nix
        #inputs.home-manager.nixosModules.default
	auto-cpufreq.nixosModules.default
      ];
    };

    homeConfigurations."friday" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [ 
        ./home-manager/home.nix 
        ./home-manager/hyprland.nix
      ];

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
      extraSpecialArgs = { 
        localflakes =  inputs;
        inherit localbuilds;
      };
    };
  };
}
