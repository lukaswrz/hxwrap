{
  description = "A wrapper for Helix that provides language support";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };
    devenv.url = "github:cachix/devenv";
  };

  outputs = {
    self,
    nixpkgs,
    flake-parts,
    devenv,
    devenv-root,
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        devenv.flakeModule
      ];

      systems = nixpkgs.lib.systems.flakeExposed;

      flake = {
        lib = nixpkgs.lib.extend (import ./lib.nix);

        nixosConfigurations = self.lib.genNixosConfigurations {inherit inputs;};
      };

      perSystem = {
        pkgs,
        system,
        ...
      }: {
        _module.args.pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        devenv.shells.default = {
          devenv.root = let
            devenvRootFileContent = builtins.readFile devenv-root.outPath;
          in
            pkgs.lib.mkIf (devenvRootFileContent != "") devenvRootFileContent;

          name = "hxwrap";

          imports = [
            ./devenv.nix
          ];
        };

        packages.default = pkgs.callPackage ./package.nix {};
      };
    };
}
