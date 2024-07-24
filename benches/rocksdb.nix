let
  versions = builtins.fromJSON (builtins.readFile ../versions.json);
in

{ stdenv, pkgs }:

stdenv.mkDerivation rec {
  name = "rocksdb";
  src = pkgs.fetchFromGitHub {
    owner = "facebook";
    repo = "rocksdb";
    rev = versions.${name}.rev;
    sha256 = versions.${name}.sha256;
  };
  nativeBuildInputs = with pkgs; [ bash util-linux which gflags perl snappy ];
  postPatch = "patchShebangs build_tools/*";
  makeFlags = [
    "DISABLE_WARNING_AS_ERROR=1"
    "DISABLE_JEMALLOC=1"
  ];
  enableParallelBuilding = true;
  buildFlags = [ "db_bench" ];
  installPhase = "mkdir $out && cp -r * $out";
}
