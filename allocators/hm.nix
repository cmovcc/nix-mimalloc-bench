let
  versions = builtins.fromJSON (builtins.readFile ../versions.json);
in

{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "hm";
  src = fetchFromGitHub {
    owner = "GrapheneOS";
    repo = "hardened_malloc";
    rev = versions.${name}.rev;
    sha256 = versions.${name}.sha256;
    #sha256 = lib.fakeHash;
  };
  installPhase = "mkdir -p $out/out && cp out/libhardened_malloc.so $out/out";
}
