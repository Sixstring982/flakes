{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    {
      templates.ocaml-dune-project = {
        description =
          "Simple OCaml dune project template";
        path = ./templates/ocaml/dune-project;
      };
    };
}
