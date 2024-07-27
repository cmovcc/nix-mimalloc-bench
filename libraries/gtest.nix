let
  versions = builtins.fromJSON (builtins.readFile ../versions.json);
in

{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "gtest";
  src = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = versions.${name}.rev;
    sha256 = versions.${name}.sha256;
  };
  installPhase = "mkdir $out && cp -r * $out";
}
