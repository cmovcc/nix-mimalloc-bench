# nix-mimalloc-bench

[mimalloc-bench](https://github.com/daanx/mimalloc-bench/) is a nice memory
allocators benchmarking suite. It contains scripts to build a variety of
allocators and benchmarks, so that built allocators can then be benched.

During the development of StarMalloc, a memory allocator whose CI relies on
Nix, it was sometimes frustrating to not be able to bench it automatically
using Nix, e.g. for performance regressions. This is now possible using this
project!

Also, a collection of various software comes with a collection of various build
requirements. Using Nix declarative builds can help with that. It can also be
helpful to reduce useless rebuilding thanks to the integrated memoization
feature.

Note: I intend to try to upstream as much as possible of this repository. As
many improvements are required (e.g. many memory allocators supported by
mimalloc-bench are missing) and this largely needs to be discussed, creating a
dedicated repository is a simpler first target.
