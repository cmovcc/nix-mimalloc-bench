{ stdenv, pkgs, lib, bench-stage4, allocs, benches }:

let
  # list of allocators to be benched, part of bench.sh argument
  str_allocs = lib.concatMapStrings
    (name: "${name} ")
    (builtins.attrNames allocs);
  str_allocs_installed = lib.concatMapStrings
    (name: "${name}: \n")
    (builtins.attrNames allocs);
  # list of benched to be run, part of bench.sh argument
  str_benches = lib.concatMapStrings
    (name: "${(builtins.getAttr name benches).benches} ")
    (builtins.attrNames benches);
  # fixup phase before actually running benchmarks
  objs_benches = builtins.map (name: builtins.getAttr name benches) (builtins.attrNames benches);
  build_phase = lib.strings.concatMapStrings (obj:
    "${obj.cmd2}"
  ) objs_benches;
in
stdenv.mkDerivation {
  name = "run";
  src = bench-stage4;
  # TODO: should be part of benchmarks list
  nativeBuildInputs = with pkgs; [
    util-linux bash time
    readline #lua
    bc #redis
    ghostscript_headless #gs
    ruby #rbstress
    z3 #z3
    cmake gmp #lean
  ];
  dontUseCmakeConfigure = true;
  postPatch = ''
    substituteInPlace bench.sh --replace "/usr/bin/env" "${pkgs.coreutils}/bin/env"
  '';
  buildPhase = ''
    ${build_phase}
    # allt is an alias for tests_all{1,2,3,4} instead of tests_all{1,2}
    sed -i 's/tests_allt="$tests_all1 $tests_all2"/tests_allt="$tests_all1 $tests_all2 $tests_all3 $tests_all4"/' bench.sh
    # lean and lean-mathlib should not be excluded
    sed -i 's/tests_exclude="$tests_exclude lean lean-mathlib"/tests_exclude="$tests_exclude"/' bench.sh
    pushd out/bench
    # benchmark
    #time bash ../../bench.sh sys ${str_allocs} ${str_benches}
    time bash ../../bench.sh alla allt no-security no-spec no-spec-bench
    popd
  '';
  # false is used so that it fails and derivation can be rerun, is this reasonable?
  installPhase = "cp out/bench/benchres.csv $out && false";
}
