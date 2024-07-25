let
  versions = builtins.fromJSON (builtins.readFile ../versions.json);
in

{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "sg";
  src = fetchFromGitHub {
    owner = "ssrg-vt";
    repo = "SlimGuard";
    rev = versions.${name}.rev;
    sha256 = versions.${name}.sha256;
  };
  installPhase = "mkdir $out && cp libSlimGuard.so $out";
}
