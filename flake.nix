{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    emanote.url = "github:srid/emanote";
    nixpkgs.follows = "emanote/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, flake-utils, emanote, nixpkgs, ... }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" "aarch64-linux" ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      rec {
        defaultApp = apps.live;
        apps = {
          live = rec {
            type = "app";
            # '' is required for escaping ${} in nix
            script = pkgs.writeShellApplication {
              name = "emanoteRun.sh";
              text = ''
                set -xe
                export PORT="''${EMANOTE_PORT:-7072}"
                ${emanote.defaultPackage.${system}}/bin/emanote run --port "$PORT"
              '';
            };
            program = "${script}/bin/emanoteRun.sh";
          };
        };
        devShell = pkgs.mkShell {
          buildInputs = [ pkgs.nixpkgs-fmt ];
        };
      });
}
