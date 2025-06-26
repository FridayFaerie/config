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

    # nh = {
    #   url = "github:nix-community/nh";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # Home-manager things
    quickshell = {
      # url = "github:quickshell-mirror/quickshell";
      url = "git+file:///home/friday/nix-inputs/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixCats = {
      # url = "github:FridayFaerie/nixCats/";
      url = "git+file:///home/friday/nix-inputs/nixCats";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # wl_shimeji = {
    #   url = "path:/home/friday/nix-inputs/wl_shimeji";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # zen-browser = {
    #   url = "github:0xc000022070/zen-browser-flake";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    programsdb = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    textfox = {
      url = "github:adriankarlen/textfox";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## HYPRLAND THINGS
    ## no nixpkgs override for cache reasons
    # hyprland.url = "github:hyprwm/Hyprland";
    hyprland.url = "github:hyprwm/hyprland?rev=5a348fb7dfaf398922c119d21acb7d7f831f8688";

    ## hyprland plugins
    hypr-dynamic-cursors = {
      url = "github:VirtCode/hypr-dynamic-cursors?rev=e95d32863664744057b61984a87d2ab487f4b858";
      inputs = {
        hyprland.follows = "hyprland";
        nixpkgs.follows = "hyprland/nixpkgs";
      };
    };
    hyprland-plugins = {
      # url = "github:hyprwm/hyprland-plugins";
      url = "github:hyprwm/hyprland-plugins";
      inputs = {
        hyprland.follows = "hyprland";
        nixpkgs.follows = "hyprland/nixpkgs";
      };
    };
    hypr-darkwindow = {
      url = "github:micha4w/Hypr-DarkWindow";
      inputs.hyprland = {
        follows = "hyprland";
      };
    };
    hyprgreen = {
      url = "github:FridayFaerie/hyprgreen";
      inputs.hyprland = {
        follows = "hyprland";
      };
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        nixpkgs.follows = "hyprland/nixpkgs";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
        hyprgraphics.follows = "hyprland/hyprgraphics";
      };
    };
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs = {
        nixpkgs.follows = "hyprland/nixpkgs";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        hyprland-protocols.follows = "hyprland/hyprland-protocols";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
      };
    };
    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs = {
        nixpkgs.follows = "hyprland/nixpkgs";
        hyprutils.follows = "hyprland/hyprutils";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
      };
    };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs = {
        nixpkgs.follows = "hyprland/nixpkgs";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
        hyprgraphics.follows = "hyprland/hyprgraphics";
      };
    };
    hyprsunset = {
      url = "github:hyprwm/hyprsunset";
      inputs = {
        nixpkgs.follows = "hyprland/nixpkgs";
        hyprutils.follows = "hyprland/hyprutils";
        hyprland-protocols.follows = "hyprland/hyprland-protocols";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
      };
    };
  };

  outputs = {
    self,
    nixpkgs,
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
  in {
    nixosConfigurations = {
      friday = nixpkgs.lib.nixosSystem {
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
          inherit inputs;
        };
      };
    };

    homeConfigurations."friday" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        ./home-manager/hyprland.nix
        inputs.textfox.homeManagerModules.default
        ./home-manager/home.nix
      ];

      extraSpecialArgs = {
        inherit inputs;
        inherit localbuilds;
      };
    };

    homeConfigurations."bun" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        ./bun/home.nix
      ];

      extraSpecialArgs = {
        inherit inputs;
        inherit localbuilds;
      };
    };

    formatter.x86_64-linux = pkgs.alejandra;
  };
}
