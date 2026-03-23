# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

cmusfm is a Last.fm/Libre.fm scrobbler for the cmus music player, written in C. It runs as a status display program invoked by cmus, communicating with a background daemon over a Unix socket to submit track plays and show now-playing notifications.

## Build Commands

```sh
# Configure and build (out-of-tree build)
cmake -B build                                        # minimal
cmake -B build -DENABLE_LIBNOTIFY=ON                  # with desktop notifications
cmake -B build -DENABLE_DEBUG=ON -DENABLE_MANPAGES=ON # debug + man pages
cmake --build build

# Run all tests
cd build && ctest

# Run tests in parallel (as CI does)
cd build && ctest -j8 --output-on-failure

# Run a single test
cd build && ctest -R test-server-submit01
```

Dependencies: libcurl (dev), pkg-config. Optional: libnotify (>= 0.7), libcrypto (OpenSSL), python3-docutils (rst2man for man pages). Avoid libcurl 7.71.0 (curl_easy_escape bug).

## Architecture

**Multi-process design:**

1. **Status display program** (`main.c`) — cmus invokes `cmusfm` with track metadata on every status change. It connects to the daemon's Unix socket and sends a binary `cmusfm_data_record`. If the daemon isn't running, it spawns one.

2. **Daemon server** (`server.c`) — long-running process that receives track updates via the socket, applies scrobble timing rules (>50% played or >=240s), and submits to Last.fm. Monitors config file changes via inotify when available.

3. **Scrobbler library** (`libscrobbler2.c`) — Last.fm API v2.0 client using libcurl. Handles auth, now-playing, and scrobble requests. Supports custom service URLs for Libre.fm compatibility.

4. **Offline cache** (`cache.c`) — binary cache with checksums for tracks that failed to submit. Retried on subsequent daemon runs.

5. **Config** (`config.c`) — reads `~/.config/cmus/cmusfm.conf`. Supports custom POSIX ERE patterns with named captures: `(?A...)` artist, `(?T...)` title, `(?B...)` album, `(?N...)` track number.

6. **Notifications** (`notify.c`) — optional libnotify desktop notifications with cover art detection.

## Testing

Tests live in `test/` and are built as standalone programs that `#include` source files directly with mock implementations (see `test-server.inc` for mock scrobbler functions). Each test binary is both built and run by `ctest`.

## Code Style

- Tab indentation (likely 8-wide based on continuation alignment)
- K&R-style braces
- snake_case for functions, UPPER_CASE for macros/constants
- Header guards: `CMUSFM_<FILENAME>_H_`
- SPDX license tags in every file
- Conditional includes guarded by `#if HAVE_CONFIG_H`
