let
  versions = builtins.fromJSON (builtins.readFile ../versions.json);
in

{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "hml";
  src = fetchFromGitHub {
    owner = "GrapheneOS";
    repo = "hardened_malloc";
    rev = versions.${name}.commit;
    sha256 = versions.${name}.sha256;
  };
  makeFlags = [ "VARIANT=light" ];
  installPhase = "mkdir -p $out/out-light && cp out-light/libhardened_malloc-light.so $out/out";
}
