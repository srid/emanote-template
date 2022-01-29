{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    emanote.url = "github:srid/emanote";
    nixpkgs.follows = "emanote/nixpkgs";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, flake-compat, emanote, nixpkgs }:
    let
      system = "aarch64-darwin";  # FIXME: all platforms
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      defaultApp.${system} = self.apps.${system}.live;
      defaultPackage.${system} = self.website;
      apps."${system}" = {
        live = rec {
          type = "app";
          # '' is required for escaping ${} in nix
          script = pkgs.writers.writeBash "emanoteRun.sh" ''
            set -xe
            export PORT="''${EMANOTE_PORT:-7072}"
            ${emanote.defaultPackage.${system}}/bin/emanote run --port $PORT
          '';
          program = builtins.toString script;
        };
      };
    };
}