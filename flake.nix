{
  description = "Flake for my Linux Guitar Rig";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.05";
    flake-utils.url = "github:numtide/flake-utils";

    nix-formatter-pack.url = "github:Gerschtli/nix-formatter-pack";
    nix-formatter-pack.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self
    , nixpkgs
    , nix-formatter-pack
    , flake-utils
    }:

    flake-utils.lib.eachDefaultSystem (system:

    let

      pkgs = import nixpkgs {
        inherit system;
        overlays = [ ];
      };
      # Import subflake packages
      pwar = (import ./PWAR/linux/flake.nix).outputs.packages.${system}.default;
      pwGhostRec = (import ./pw-ghost-rec/flake.nix).outputs.packages.${system}.default;
    in
    {
      formatter = pkgs.nixpkgs-fmt;
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          pwar
          pwGhostRec
          pipewire
          pw-link
          pw-jack
          jq
          libnotify
        ];
      };
      packages.pwar = pwar;
      packages.pw-ghost-rec = pwGhostRec;
      packages.start = pkgs.writeShellApplication {
        name = "start";
        runtimeInputs = [ pkgs.bash pkgs.coreutils pkgs.gnused pkgs.gawk pwar pwGhostRec ];
        text = builtins.readFile ./scripts/start.sh;
      };
      packages.default = self.packages.${system}.start;
      apps.default = flake-utils.lib.mkApp {
        drv = self.packages.${system}.start;
      };
    });
}
