{nixpkgs, ...}: let
  allSystems = [
    "x86_64-linux" # 64-bit Intel/AMD Linux
    "aarch64-linux" # 64-bit ARM Linux
    "x86_64-darwin" # 64-bit Intel macOS
    "aarch64-darwin" # 64-bit ARM macOS
  ];
  forAllSystems = f:
    nixpkgs.lib.genAttrs allSystems (system:
      f {
        # pkgs = import nixpkgs { inherit system; };
        pkgs = nixpkgs.legacyPackages.${system};
      });
in {
  packages = forAllSystems ({pkgs}: {
    default = pkgs.buildGoModule rec {
      pname = "snitch";
      version = "1.0.2";
      src = pkgs.fetchFromGitHub {
        owner = "tsoding";
        repo = "snitch";
        rev = "master";
        sha256 = "sha256-M3FZs4GL0AXXUFH+VHFTI12aZx12RfgOWJltU6sOMfw=";
      };
      vendorHash = "sha256-QAbxld0UY7jO9ommX7VrPKOWEiFPmD/xw02EZL6628A=";
    };
  });
}
