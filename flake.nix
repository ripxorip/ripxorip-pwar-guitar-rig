{
  description = "Flake for my Linux Guitar Rig";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.05";
    flake-utils.url = "github:numtide/flake-utils";

    nix-formatter-pack.url = "github:Gerschtli/nix-formatter-pack";
    nix-formatter-pack.inputs.nixpkgs.follows = "nixpkgs";

    # Add subflakes as flake inputs
    pwar.url = "path:./PWAR/linux";
    pw-ghost-rec.url = "path:./pw-ghost-rec";
  };

  outputs = { self, nixpkgs, nix-formatter-pack, flake-utils, pwar, pw-ghost-rec }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        pwarPkg = pwar.packages.${system}.default;
        pwGhostRecPkg = pw-ghost-rec.packages.${system}.default;
      in {
        formatter = pkgs.nixpkgs-fmt;
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            pwarPkg
            pwGhostRecPkg
            pipewire
            pw-link
            pw-jack
            jq
            libnotify
          ];
        };
        packages.pwar = pwarPkg;
        packages.pw-ghost-rec = pwGhostRecPkg;
        packages.start = pkgs.writeShellApplication {
          name = "start";
          runtimeInputs = [ pkgs.bash pkgs.coreutils pkgs.gnused pkgs.gawk pwarPkg pwGhostRecPkg ];
          text = builtins.readFile ./scripts/start.sh;
        };
        packages.default = self.packages.${system}.start;
        apps.default = flake-utils.lib.mkApp {
          drv = self.packages.${system}.start;
        };
      }
    );
}
