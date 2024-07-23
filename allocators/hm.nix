let
  versions = builtins.fromJSON (builtins.readFile ../versions.json);
in

{ stdenv, version, lib, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "hm";
  src = fetchFromGitHub {
    owner = "GrapheneOS";
    repo = "hardened_malloc";
    rev = versions.hm.commit;
    sha256 = versions.hm.sha256;
    #sha256 = lib.fakeHash;
  };
  installPhase = "touch $out";
}
