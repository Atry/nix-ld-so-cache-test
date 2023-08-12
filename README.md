This repository demonstrates how to fix https://github.com/cachix/devenv/issues/773 by using `NIX_LD_SO_CACHE` introduced by https://github.com/NixOS/nixpkgs/pull/248777

By using `NIX_LD_SO_CACHE` with `nixpkgs` from https://github.com/Atry/nixpkgs/tree/NIX_LD_SO_CACHE, the following command will work without any error:

```
nix develop --impure
```
