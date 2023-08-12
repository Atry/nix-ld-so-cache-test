{
  inputs = {
    nixpkgs.url = "github:Atry/nixpkgs/NIX_LD_SO_CACHE";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = { self, nixpkgs, devenv, systems, ... } @ inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      devShells = forEachSystem
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          {
            default = devenv.lib.mkShell {
              inherit inputs pkgs;
              modules = [
                {

                  env.NIX_LD_SO_CACHE = pkgs.runCommand "ld.so.cache" {} ''
                    ${nixpkgs.lib.strings.escapeShellArg pkgs.glibc.bin}/bin/ldconfig -C $out $f ${
                      nixpkgs.lib.strings.escapeShellArg (
                        pkgs.writeTextFile {
                          name = "ld.so.conf";
                          text = ''
                            ${pkgs.stdenv.cc.cc.lib}/lib
                          '';
                        }
                      )
                    }
                  '';

                  enterShell = ''
                    python -m grpc_tools.protoc --help
                  '';

                  languages.python = {
                    enable = true;
                    venv = {
                      enable = true;
                      requirements = ''
                        grpcio-tools
                      '';
                    };
                  };
                }
              ];
            };
          });
    };
}