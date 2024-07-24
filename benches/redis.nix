let
  versions = builtins.fromJSON (builtins.readFile ../versions.json);
in

{ stdenv, pkgs }:

stdenv.mkDerivation rec {
  name = "redis";
  src = builtins.fetchTarball {
    url = "http://download.redis.io/releases/redis-${versions.${name}.commit}.tar.gz";
    sha256 = versions.${name}.sha256;
  };
  nativeBuildInputs = with pkgs; [ pkg-config ];
  makeFlags = [
    "USE_JEMALLOC=no"
    "MALLOC=libc"
    "BUILD_TLS=no"
  ];
  enableParallelBuilding = true;
  installPhase = "mkdir $out && cp -r * $out";
}
