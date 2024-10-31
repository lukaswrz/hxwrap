{
  description = "A wrapper for Helix that provides language support";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}: let
    supportedSystems = nixpkgs.lib.systems.flakeExposed;
    forAllSupportedSystems = f:
      nixpkgs.lib.genAttrs supportedSystems (
        system:
          f (import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          })
      );
  in {
    packages = forAllSupportedSystems (pkgs: {
      default = let
        package = pkgs.helix;
      in
        pkgs.symlinkJoin {
          name = package.pname;
          paths = [package];
          buildInputs = [pkgs.makeWrapper];
          postBuild = ''
            wrapProgram $out/bin/${package.meta.mainProgram} \
              --suffix PATH : ${pkgs.lib.makeBinPath (builtins.attrValues {
              inherit
                (pkgs)
                # LSP
                clang-tools
                clojure-lsp
                cmake-language-server
                dart
                docker-compose-language-service
                dockerfile-language-server-nodejs
                emmet-ls
                gopls
                jdt-language-server
                kotlin-language-server
                lua-language-server
                marksman
                nil
                perlnavigator
                pyright
                rust-analyzer
                taplo
                terraform-ls
                texlab
                tinymist
                vscode-langservers-extracted
                yaml-language-server
                zls
                # DAP
                omnisharp-roslyn
                lldb
                netcoredbg
                delve
                ;
              inherit
                (pkgs.nodePackages_latest)
                # LSP
                bash-language-server
                graphql-language-service-cli
                intelephense
                svelte-language-server
                typescript-language-server
                vls
                ;
              inherit
                (pkgs.rubyPackages)
                # LSP
                solargraph
                ;
              inherit
                (pkgs.python3Packages)
                # LSP
                python-lsp-server
                ;
              inherit
                (pkgs.kdePackages)
                # LSP
                qtdeclarative
                ;
              inherit
                (pkgs.ocamlPackages)
                # LSP
                ocaml-lsp
                ;
            })}
          '';
          inherit (package) meta;
        };
    });
  };
}
