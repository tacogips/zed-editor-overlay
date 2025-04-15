# Zed Editor Nix オーバーレイ

このリポジトリには、[Zed Editor](https://zed.dev/)の最新バージョンを提供するNix flakeが含まれています。Zed EditorはAtomとTree-sitterの作者によって開発された高性能なマルチプレイヤーコードエディタです。

## 特徴

- Zed Editorのカスタムオーバーレイ
- 最新バージョン（現在0.182.0）
- LinuxとmacOSの両方をサポート
- 拡張機能のためのFHS環境オプションを含む
- スタンドアロンパッケージとしてインストール可能

## 使用方法

### クイックインストール

このflakeを使用してZed Editorを直接インストールする：

```bash
nix profile install github:tacogips/zed-editor-overlay
```

またはインストールせずに実行する：

```bash
nix run github:tacogips/zed-editor-overlay
```

### 自分のFlakeで使用する

`flake.nix`にこのリポジトリを入力として追加する：

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    zed-overlay.url = "github:tacogips/zed-editor-overlay";
  };

  outputs = { self, nixpkgs, zed-overlay, ... }:
    {
      # NixOSシステム向け
      nixosConfigurations.your-hostname = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ pkgs, ... }: {
            nixpkgs.overlays = [ zed-overlay.overlays.default ];
            environment.systemPackages = [ pkgs.zed-editor ];
          })
        ];
      };
      
      # home-manager向け
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

## アップデート

Zed Editorの最新バージョンに更新するには：

1. `pkgs/zed-editor/default.nix`のバージョン番号を更新
2. `src`と`cargoHash`のハッシュ値を更新
3. `nix build`でビルドしてテスト

## 開発シェル

このflakeはZed Editorを含む開発シェルも提供します：

```bash
nix develop
```

## ライセンス

このオーバーレイはMITライセンスの条件下で提供されています。Zed Editor自体はGPL-3.0ライセンスの下でライセンスされています。