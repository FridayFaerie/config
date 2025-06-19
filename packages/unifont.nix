{
  # stdenvNoCC,
  # lib,
  # fetchFromGitHub,
  pkgs ? import <nixpkgs> { },
}:
{
  default = pkgs.stdenvNoCC.mkDerivation {
    pname = "unifont";
    version = "0.0.2";

    src = pkgs.fetchFromGitHub {
      owner = "stgiga";
      repo = "UnifontEX";
      rev = "0d38750acfcec8fb222703968ebed7660b918146";
      sha256 = "sha256-H/jCOgMvKpAVsHxWotQQ6c/+ovjEujIQZGQET9Vgpuk=";
    };

    installPhase = ''
      install -m444 -Dt $out/share/fonts/truetype *.ttf
    '';
  };
}
