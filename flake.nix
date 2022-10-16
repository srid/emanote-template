{
  nixConfig.extra-substituters = "https://cache.garnix.io";
  nixConfig.extra-trusted-public-keys = "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=";

  inputs = {
    emanote.url = "github:EmaApps/emanote";
    nixpkgs.follows = "emanote/nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit self; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [ inputs.emanote.flakeModule ];
      perSystem = { self', pkgs, system, ... }: {
        emanote = {
          # By default, the 'emanote' flake input is used.
          # package = inputs.emanote.packages.${system}.default;
          sites."default" = {
            layers = [ ./content ];
            layersString = [ "./content" ];
            # port = 8080;
            baseUrl = "/emanote-template/"; # Change to "/" (or remove it entirely) if using CNAME
            # prettyUrls = true;
          };
        };
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.nixpkgs-fmt
          ];
        };
        formatter = pkgs.nixpkgs-fmt;
      };
    };
}
