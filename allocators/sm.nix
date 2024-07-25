let
  versions = builtins.fromJSON (builtins.readFile ../versions.json);
in

{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "sm";
  src = fetchFromGitHub {
    owner = "kuszmaul";
    repo = "SuperMalloc";
    rev = versions.${name}.rev;
    sha256 = versions.${name}.sha256;
  };
  # unmaintained
  NIX_CFLAGS_COMPILE = "-Wno-alloc-size-larger-than";
  enableParallelBuilding = true;
  installPhase = "mkdir -p $out/release/lib/ && cp release/lib/libsupermalloc.so $out/release/lib";
}
