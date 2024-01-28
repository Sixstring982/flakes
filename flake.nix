{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    {
      templates = {
        ocaml-dune-project = {
          description =
            "Simple OCaml dune project template";
          path = ./templates/ocaml/dune-project;
        };

        haskell-rio = {
          description =
            "Haskell project template using the RIO library";
          path = ./templates/haskell/rio;
        };
      };
    };
}
