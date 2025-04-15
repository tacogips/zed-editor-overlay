# Zed Editor Nix Overlay

This repository contains a Nix flake that provides an overlay for the latest version of [Zed Editor](https://zed.dev/), a high-performance, multiplayer code editor from the creators of Atom and Tree-sitter.

## Features

- Custom overlay for Zed Editor
- Up-to-date version (currently 0.182.0)
- Supports both Linux and macOS
- Includes FHS environment option for extensions
- Can be installed as a standalone package

## Usage

### Quick Install

To install Zed Editor directly using this flake:

```bash
nix profile install github:tacogips/zed-editor-overlay
```

Or run it without installing:

```bash
nix run github:tacogips/zed-editor-overlay
```

### Using in Your Own Flake

Add this repository as an input in your `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    zed-overlay.url = "github:tacogips/zed-editor-overlay";
  };

  outputs = { self, nixpkgs, zed-overlay, ... }:
    {
      # For NixOS systems
      nixosConfigurations.your-hostname = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ pkgs, ... }: {
            nixpkgs.overlays = [ zed-overlay.overlays.default ];
            environment.systemPackages = [ pkgs.zed-editor ];
          })
        ];
      };
      
      # For home-manager
      homeConfigurations.your-username = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux.extend zed-overlay.overlays.default;
        modules = [
          {
            home.packages = [ pkgs.zed-editor ];
          }
        ];
      };
    };
}
```

## Updating

To update to the latest version of Zed Editor:

1. Update the version number in `pkgs/zed-editor/default.nix`
2. Update the hash values for `src` and `cargoHash`
3. Test by building: `nix build`

## Development Shell

This flake also provides a development shell with Zed Editor:

```bash
nix develop
```

## License

This overlay is provided under the terms of the MIT License. Zed Editor itself is licensed under the GPL-3.0 license.