{
  inputs = {
    emanote.url = "github:srid/emanote/master";
    nixpkgs.follows = "emanote/nixpkgs";
    flake-utils.follows = "emanote/flake-utils";
    flake-compat.follows = "emanote/flake-compat";
  };

  outputs = { self, flake-utils, emanote, nixpkgs, ... }@inputs:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        rec {
          defaultApp = apps.live;
          defaultPackage = website;
          apps = {
            live = rec {
              type = "app";
              # '' is required for escaping ${} in nix
              script = pkgs.writeShellApplication {
                name = "emanoteRun.sh";
                text = ''
                  set -xe
                  export PORT="''${EMANOTE_PORT:-7072}"
                  cd ./content && ${emanote.defaultPackage.${system}}/bin/emanote run --port "$PORT"
                '';
              };
              program = "${script}/bin/emanoteRun.sh";
            };
          };
          website =
            pkgs.runCommand "emanote-website" { }
              ''
                mkdir $out
                cd ${self}/content && ${emanote.defaultPackage.${system}}/bin/emanote \
                  gen $out
              '';
          devShell = pkgs.mkShell {
            buildInputs = [ pkgs.nixpkgs-fmt ];
          };
        }
      ) //
    {
      # Hercules CI support: https://hercules-ci.com/
      herculesCI.ciSystems = [ "x86_64-linux" ];
    };
}
