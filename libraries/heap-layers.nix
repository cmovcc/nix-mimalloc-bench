let
  versions = builtins.fromJSON (builtins.readFile ../versions.json);
in

{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "heap-layers";
  src = fetchFromGitHub {
    owner = "emeryberger";
    repo = "heap-layers";
    rev = versions.${name}.rev;
    sha256 = versions.${name}.sha256;
  };
  installPhase = "mkdir $out && cp -r * $out";
}
