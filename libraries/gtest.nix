let
  versions = builtins.fromJSON (builtins.readFile ../versions.json);
in

{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "gtest";
  src = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    #rev = versions.${name}.rev;
    rev = "main";
    #sha256 = versions.${name}.sha256;
    sha256 = "sha256-Cd1/ud/2irrzjSeeAaWGdFCYDmfi2OHAqO96cQJMq4o=";
  };
  installPhase = "mkdir $out && cp -r * $out";
}
