# SPDX-FileCopyrightText: 2014-2024 Arkadiusz Bokowy and contributors
# SPDX-License-Identifier: GPL-3.0-or-later
{ lib
, stdenv
, cmake
, pkg-config
, curl
, libnotify
, python3Packages
, enableLibnotify ? false
, enableManpages ? false
}:

stdenv.mkDerivation {
  pname = "cmusfm";
  version = "0.4.2";

  src = lib.cleanSource ./.;

  nativeBuildInputs = [
    cmake
    pkg-config
  ] ++ lib.optionals enableManpages [
    python3Packages.docutils
  ];

  buildInputs = [
    curl
  ] ++ lib.optionals enableLibnotify [
    libnotify
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_LIBNOTIFY" enableLibnotify)
    (lib.cmakeBool "ENABLE_MANPAGES" enableManpages)
  ];

  doCheck = true;

  meta = with lib; {
    description = "Last.fm scrobbler for the cmus music player";
    homepage = "https://github.com/arkq/cmusfm";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "cmusfm";
  };
}
