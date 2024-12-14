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
      default = pkgs.callPackage ./package.nix {};
    });
  };
}
