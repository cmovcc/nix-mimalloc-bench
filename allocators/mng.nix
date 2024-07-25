let
  versions = builtins.fromJSON (builtins.readFile ../versions.json);
in

{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "mng";
  src = fetchFromGitHub {
    owner = "richfelker";
    repo = "mallocng-draft";
    rev = versions.${name}.rev;
    sha256 = versions.${name}.sha256;
  };
  installPhase = "mkdir $out && cp libmallocng.so $out";
}
