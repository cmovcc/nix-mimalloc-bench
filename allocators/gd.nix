let
  versions = builtins.fromJSON (builtins.readFile ../versions.json);
in

{ clangStdenv, fetchFromGitHub }:

clangStdenv.mkDerivation rec {
  name = "gd";
  src = fetchFromGitHub {
    owner = "UTSASRG";
    repo = "Guarder";
    rev = versions.${name}.commit;
    sha256 = versions.${name}.sha256;
  };
  installPhase = "mkdir $out && cp libguarder.so $out";
}
