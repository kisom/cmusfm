# SPDX-FileCopyrightText: 2014-2024 Arkadiusz Bokowy and contributors
# SPDX-License-Identifier: GPL-3.0-or-later
{
  description = "Last.fm scrobbler for the cmus music player";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgsFor = system: nixpkgs.legacyPackages.${system};
    in
    {
      packages = forAllSystems (system:
        let pkgs = pkgsFor system; in
        {
          default = self.packages.${system}.cmusfm;
          cmusfm = pkgs.callPackage ./default.nix { };
        });

      devShells = forAllSystems (system:
        let pkgs = pkgsFor system; in
        {
          default = import ./shell.nix { inherit pkgs; };
        });
    };
}
