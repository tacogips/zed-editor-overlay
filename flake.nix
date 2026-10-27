{
  description = "Zed Editor overlay and installation";

  inputs = {
    nixpkgs.url = "github:tacogips/nixpkgs-security/d2a93d2fe7820d90eaa10af53891412ec3614f56";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        };
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
            pkgs.zed-editor
          ];
          shellHook = ''
            echo "Zed Editor development environment loaded."
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