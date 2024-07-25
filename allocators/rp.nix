let
  versions = builtins.fromJSON (builtins.readFile ../versions.json);
in

{ clangStdenv, fetchFromGitHub, pkgs }:

clangStdenv.mkDerivation rec {
  name = "rp";
  src = fetchFromGitHub {
    owner = "mjansson";
    repo = "rpmalloc";
    rev = versions.${name}.rev;
    sha256 = versions.${name}.sha256;
  };
  nativeBuildInputs = with pkgs; [ python3 ninja ];
  configurePhase = "python3 configure.py";
  # first warning is fixed using current develop branch
  # second warning is fixed using 1.4.5 release
  # TODO: mimalloc-bench PR?
  NIX_CFLAGS_COMPILE = "-Wno-embedded-directive -Wno-unsafe-buffer-usage";
  installPhase = "mkdir $out && cp -r bin $out";
}
