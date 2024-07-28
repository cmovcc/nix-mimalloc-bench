let
  versions = builtins.fromJSON (builtins.readFile ../versions.json);
in

{ clangStdenv, fetchFromGitHub, pkgs, lib, hardened ? false }:

let
  targetMap = {
    "sn" = "libsnmallocshim.so";
    "sn-sec" = "libsnmallocshim-checks.so";
  };
in

clangStdenv.mkDerivation rec {
  name = if hardened then "sn-sec" else "sn";
  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "snmalloc";
    rev = versions."sn".rev;
    sha256 = versions."sn".sha256;
  };

  nativeBuildInputs = with pkgs; [ cmake ninja clang ];

  NIX_CFLAGS_COMPILE = "-Wno-ignored-attributes -D_FORTIFY=0";
  configurePhase = ''
    mkdir -p release
    cd release
    env CXX=${clangStdenv.cc}/bin/clang++ cmake -G Ninja .. -DCMAKE_BUILD_TYPE=Release
    cd ..
  '';

  # sn-sec: causes redefinition of memcpy, which is an "extern inline" function, unsupported
  # TODO: file an issue
  # reproducible using -DCXXFLAGS="-D_FORTIFY_SOURCE=2"
  hardeningDisable = lib.optionals hardened [ "fortify" ];
  buildPhase = ''
    cd release
    ninja ${targetMap.${name}}
  '';
  installPhase = "mkdir -p $out/release && cp ${targetMap.${name}} $out/release";
}
