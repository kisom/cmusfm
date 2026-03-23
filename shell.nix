# SPDX-FileCopyrightText: 2014-2024 Arkadiusz Bokowy and contributors
# SPDX-License-Identifier: GPL-3.0-or-later
{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  inputsFrom = [
    (pkgs.callPackage ./default.nix {
      enableLibnotify = true;
      enableManpages = true;
    })
  ];
}
