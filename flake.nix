{
  description = "Nixos config flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "git+https://github.com/NixOS/nixpkgs?shallow=1&ref=nixos-unstable";
    # altnixpkgs.url = "github:NixOS/nixpkgs/2631b0b7abce";

    nixpkgs = {
      url = "git+https://github.com/NixOS/nixpkgs?shallow=1&ref=nixos-unstable";
    };

    # nixos config things

    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home-manager things
    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      # url = "git+https://git.outfoxxed.me/outfoxxed/quickshell?ref=qt6.9.0";
      # inputs.nixpkgs.follows = "altnixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixCats = {
      url = "./packages/nixCats/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # zen-browser = {
    #   url = "github:0xc000022070/zen-browser-flake";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    programsdb.url = "github:wamserma/flake-programs-sqlite";
  };

  outputs = {
    self,
    nixpkgs,
    # altnixpkgs,
    auto-cpufreq,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    localbuilds = {
      snitch = import ./packages/snitch.nix {inherit nixpkgs;};
      unifont = import ./packages/unifont.nix {inherit nixpkgs;};
    };
    # pkgs = import nixpkgs {
    #   inherit system;
    #   config = {
    #     # allowUnfree = true;
    #   };
    # };
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./nixos/configuration.nix
          ./nixos/hardware-configuration.nix
          auto-cpufreq.nixosModules.default
        ];
      };

      # from https://haseebmajid.dev/posts/2024-02-04-how-to-create-a-custom-nixos-iso/
      iso = nixpkgs.lib.nixosSystem {
        modules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
          ./iso/configuration.nix
        ];
        specialArgs = {
          inherit inputs outputs;
        };
      };
    };

    homeConfigurations."friday" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        # home-manager.nixosModules.default
        ./home-manager/home.nix
        ./home-manager/hyprland.nix
      ];

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
      extraSpecialArgs = {
        localflakes = inputs;
        inherit localbuilds;
      };
    };

    homeConfigurations."bun" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        ./bun/home.nix
      ];

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
      extraSpecialArgs = {
        localflakes = inputs;
        inherit localbuilds;
      };
    };

    formatter.x86_64-linux = pkgs.alejandra;
  };
}
