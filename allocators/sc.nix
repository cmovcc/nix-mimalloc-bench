let
  versions = builtins.fromJSON (builtins.readFile ../versions.json);
in

{ stdenv, fetchFromGitHub, pkgs }:

stdenv.mkDerivation rec {
  name = "sc";
  src = fetchFromGitHub {
    owner = "cksystemsgroup";
    repo = "scalloc";
    rev = versions.${name}.rev;
    sha256 = versions.${name}.sha256;
  };
  nativeBuildInputs = with pkgs; [
    (python3.withPackages (ps: with ps; [ gyp ]))
  ];
  configurePhase = "gyp --depth=. scalloc.gyp";
  makeFlags = [ "BUILDTYPE=Release"];
  # unmaintained
  NIX_CFLAGS_COMPILE = "-Wno-stringop-overflow -Wno-stringop-truncation";
  installPhase = "mkdir -p $out/out/Release/lib.target/ && cp out/Release/lib.target/libscalloc.so $out/out/Release/lib.target/ ";
}
