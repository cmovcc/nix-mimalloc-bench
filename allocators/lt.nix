let
  versions = builtins.fromJSON (builtins.readFile ../versions.json);
in

{ stdenv, fetchFromGitHub, lib }:

stdenv.mkDerivation rec {
  name = "lt";
  src = fetchFromGitHub {
    owner = "r-lyeh-archived";
    repo = "ltalloc";
    rev = versions.${name}.commit;
    sha256 = versions.${name}.sha256;
  };
  buildPhase = "make -C gnu.make.lib";
  installPhase = "mkdir -p $out/gnu.make.lib && cp gnu.make.lib/libltalloc.so $out/gnu.make.lib";
}
