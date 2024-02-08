{
  description = "Simple Bun project template";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        legacyPackages = nixpkgs.legacyPackages.${system};
      in
      {
        devShells = {
          default = legacyPackages.mkShell {
            packages = [
              legacyPackages.nodePackages.typescript-language-server
              legacyPackages.bun
            ];
          };
        };
      });
}

