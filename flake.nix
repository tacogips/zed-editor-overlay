{
  description = "Python development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        python = pkgs.python312;  # Using Python 3.12 which is the most recent stable version
        pythonEnv = python.withPackages (ps: with ps; [
          # Add Python packages you need here, for example:
          # numpy
          # pandas
          # requests
        ]);
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pythonEnv
          ];
          shellHook = ''
            echo "Python development environment loaded."
            echo "Python version: $(python --version)"
          '';
        };
      }
    );
}