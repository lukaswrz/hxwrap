{
  helix,
  symlinkJoin,
  pkgs,
}: let
  languageServers = [
    # C & C++
    pkgs.clang-tools
    # Clojure
    pkgs.clojure-lsp
    # Dart
    pkgs.dart
    # Go
    pkgs.gopls
    # Java
    pkgs.jdt-language-server
    # Kotlin
    pkgs.kotlin-language-server
    # Lua
    pkgs.lua-language-server
    # Nix
    pkgs.nil
    # Perl
    pkgs.perlnavigator
    # Python
    pkgs.python3Packages.python-lsp-server
    pkgs.python3Packages.python-lsp-ruff
    # Rust
    pkgs.rust-analyzer
    # Zig
    pkgs.zls
    # C#
    pkgs.omnisharp-roslyn
    # PHP
    pkgs.nodePackages_latest.intelephense
    # TypeScript
    pkgs.nodePackages_latest.typescript-language-server
    # Ruby
    pkgs.rubyPackages.solargraph
    # OCaml
    pkgs.ocamlPackages.ocaml-lsp

    # Bash
    pkgs.nodePackages_latest.bash-language-server

    # HTML & CSS tooling
    pkgs.emmet-ls
    # HTML & CSS & JSON & ESLint
    pkgs.vscode-langservers-extracted

    # Markdown
    pkgs.marksman
    # LaTeX
    pkgs.texlab
    # Typst
    pkgs.tinymist

    # CMake
    pkgs.cmake-language-server
    # Docker
    pkgs.docker-compose-language-service
    pkgs.dockerfile-language-server-nodejs
    # Terraform
    pkgs.terraform-ls

    # YAML
    pkgs.yaml-language-server
    # TOML
    pkgs.taplo

    # QML
    pkgs.kdePackages.qtdeclarative

    # Svelte
    pkgs.nodePackages_latest.svelte-language-server

    # GraphQL
    pkgs.nodePackages_latest.graphql-language-service-cli
  ];

  debugAdapters = [
    # C & C++
    pkgs.lldb
    # C#
    pkgs.netcoredbg
    # Go
    pkgs.delve
  ];

  clipboardProviders = [
    pkgs.wl-clipboard
  ];
in
  symlinkJoin {
    name = helix.pname;

    paths = [helix];

    buildInputs = [pkgs.makeWrapper];

    postBuild = ''
      wrapProgram $out/bin/${helix.meta.mainProgram} \
        --suffix PATH : ${pkgs.lib.makeBinPath (languageServers ++ debugAdapters ++ clipboardProviders)}
    '';

    inherit (helix) meta;
  }
