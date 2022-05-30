{
  nixConfig.extra-substituters = "https://cache.garnix.io";
  nixConfig.extra-trusted-public-keys = "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=";

  inputs = {
    emanote.url = "github:srid/emanote/master";
    nixpkgs.follows = "emanote/nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit self; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      # The primed versions (self', inputs') are same as the non-primed
      # versions, but with 'system' already applied.
      perSystem = { self', inputs', pkgs, system, ... }:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          emanote = inputs.emanote.packages.${system}.default;
        in
        rec {
          apps = {
            default = rec {
              type = "app";
              # '' is required for escaping ${} in nix
              program = (pkgs.writeShellApplication {
                name = "emanoteRun.sh";
                text = ''
                  set -xe
                  # Use `emanote run --port=8081` if you want to run Emanote at
                  # a particular port.
                  cd ./content && ${emanote}/bin/emanote
                '';
              }) + /bin/emanoteRun.sh;
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
                  ${emanote}/bin/emanote \
                  --layers "${configDir};${self}/content" \
                    gen $out
                '';
          };
          devShells.default = pkgs.mkShell {
            buildInputs = [ pkgs.nixpkgs-fmt ];
          };
        };
    };
}
