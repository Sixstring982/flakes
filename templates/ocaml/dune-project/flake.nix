# OCaml/Dune project template
#
# Once you init this flake, you'll also need to:
# - Change the description
# - Replace all "project-name-change-me" instances with your project name
#
# For development, simply run `nix develop`.
{
  description = "Project Description";

  inputs = {
    # Convenience functions for writing flakes
    flake-utils.url = "github:numtide/flake-utils";
    # Precisely filter files copied to the nix store
    nix-filter.url = "github:numtide/nix-filter";
  };

  outputs = { self, nix-filter, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # Legacy packages that have not been converted to flakes
        legacyPackages = nixpkgs.legacyPackages.${system};
        # OCaml packages available on nixpkgs
        ocamlPackages = legacyPackages.ocaml-ng.ocamlPackages_5_1;
        # Library functions from nixpkgs
        lib = legacyPackages.lib;

        # Filtered sources (prevents unecessary rebuilds)
        sources = {
          ocaml = nix-filter.lib {
            root = ./.;
            include = [
              ".ocamlformat"
              "dune-project"
              (nix-filter.lib.inDirectory "bin")
              (nix-filter.lib.inDirectory "lib")
              (nix-filter.lib.inDirectory "test")
            ];
          };

          nix = nix-filter.lib {
            root = ./.;
            include = [
              (nix-filter.lib.matchExt "nix")
            ];
          };
        };
      in
      {
        # Exposed packages that can be built or run with `nix build` or
        # `nix run` respectively:
        #
        #     $ nix build .#<name>
        #     $ nix run .#<name> -- <args?>
        #
        packages = {
          # The package that will be built or run by default. For example:
          #
          #     $ nix build
          #     $ nix run -- <args?>
          #
          default = self.packages.${system}.project-name-change-me;

          project-name-change-me = ocamlPackages.buildDunePackage {
            pname = "project-name-change-me";
            version = "0.0.1";
            duneVersion = "3";
            src = sources.ocaml;

            buildInputs = [
              # Ocaml package dependencies needed to build go here, e.g.:
              # ocamlPackages.opium
            ];

            strictDeps = true;

            preBuild = ''
              dune build project-name-change-me.opam
            '';
          };
        };

        # Development shells
        #
        #    $ nix develop .#<name>
        #    $ nix develop .#<name> --command dune build @test
        #
        # [Direnv](https://direnv.net/) is recommended for automatically loading
        # development environments in your shell. For example:
        #
        #    $ echo "use flake" > .envrc && direnv allow
        #    $ dune build @test
        #
        devShells = {
          default = legacyPackages.mkShell {
            # Development tools
            packages = [
              legacyPackages.fswatch
              legacyPackages.ocamlformat
              ocamlPackages.ocaml-lsp
            ];

            # Tools from packages
            inputsFrom = [
              self.packages.${system}.project-name-change-me
            ];
          };
        };
      });
}

