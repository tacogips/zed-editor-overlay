{
  description = "Zed Editor overlay and development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
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
        packages = {
          zed-editor = pkgs.zed-editor;
          default = pkgs.zed-editor;
        };
        
        apps = {
          zed-editor = {
            type = "app";
            program = "${pkgs.zed-editor}/bin/zeditor";
          };
          default = self.apps.${system}.zed-editor;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [
            pythonEnv
            pkgs.zed-editor
          ];
          shellHook = ''
            echo "Zed Editor development environment loaded."
            echo "Python version: $(python --version)"
            echo "Zed Editor version: $(zeditor --version)"
          '';
        };
      }
    ) // {
      overlays = {
        default = final: prev: {
          zed-editor = final.callPackage ./pkgs/zed-editor { };
        };
      };
    };
}