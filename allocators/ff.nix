let
  versions = builtins.fromJSON (builtins.readFile ../versions.json);
in

{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "ff";
  src = fetchFromGitHub {
    owner = "bwickman97";
    repo = "ffmalloc";
    rev = versions.${name}.commit;
    sha256 = versions.${name}.sha256;
  };
  installPhase = "mkdir $out && cp libffmallocnpmt.so $out";
}
