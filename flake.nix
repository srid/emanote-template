{
  nixConfig.extra-substituters = "https://srid.cachix.org";
  nixConfig.extra-trusted-public-keys = "srid.cachix.org-1:MTQ6ksbfz3LBMmjyPh0PLmos+1x+CdtJxA/J2W+PQxI=";

  inputs = {
    emanote.url = "github:srid/emanote/master";
    ema.url = "github:srid/ema/multisite"; # To workaround follows bug
    nixpkgs.follows = "emanote/nixpkgs";
    flake-utils.follows = "emanote/flake-utils";
    flake-compat.follows = "emanote/flake-compat"; # Used in flake-compat.nix
  };

  outputs = { self, flake-utils, emanote, nixpkgs, ... }@inputs:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        rec {
          defautPackage = packages.default;
          defaultApp = apps.default;
          apps = {
            default = rec {
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
          packages = {
            default =
              let
                configFile = (pkgs.formats.yaml { }).generate "emanote-index.yaml" {
                  template = {
                    baseUrl = "/";
                    urlStrategy = "direct";
                  };
                };
                configDir = pkgs.runCommand "emanote-deploy-layer" { } ''
                  mkdir -p $out
                  cp ${configFile} $out/index.yaml
                '';
              in
              pkgs.runCommand "emanote-static-website" { }
                ''
                  mkdir $out
                  ${emanote.defaultPackage.${system}}/bin/emanote \
                  --layers "${configDir};${self}/content" \
                    gen $out
                '';
          };
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
