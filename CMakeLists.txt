# cmusfm - CMakeLists.txt
# SPDX-FileCopyrightText: 2014-2024 Arkadiusz Bokowy and contributors
# SPDX-License-Identifier: GPL-3.0-or-later

cmake_minimum_required(VERSION 3.14)
project(cmusfm VERSION 0.4.2 LANGUAGES C)

include(CheckIncludeFile)
include(GNUInstallDirs)
find_package(PkgConfig REQUIRED)

# Options
option(ENABLE_DEBUG "Enable debugging support" OFF)
option(ENABLE_LIBNOTIFY "Enable libnotify support" OFF)
option(ENABLE_MANPAGES "Enable building of man pages (requires rst2man)" OFF)

# Required: libcurl
pkg_check_modules(LIBCURL REQUIRED IMPORTED_TARGET libcurl)
execute_process(
	COMMAND ${PKG_CONFIG_EXECUTABLE} --exact-version=7.71.0 libcurl
	RESULT_VARIABLE CURL_NOT_7_71_0)
if(CURL_NOT_7_71_0 EQUAL 0)
	message(FATAL_ERROR
		"libcurl == 7.71.0 detected.\n"
		"Because of curl_easy_escape() bug present in the curl library version 7.71.0,\n"
		"cmusfm will not work correctly. Please, upgrade or downgrade the curl library.\n"
		"Related curl bug report: https://github.com/curl/curl/issues/5601")
endif()

# Required: poll.h
check_include_file(poll.h HAVE_POLL_H)
if(NOT HAVE_POLL_H)
	message(FATAL_ERROR "poll.h header not found")
endif()

# Optional: sys/inotify.h
check_include_file(sys/inotify.h HAVE_SYS_INOTIFY_H)

# Optional: libnotify
if(ENABLE_LIBNOTIFY)
	pkg_check_modules(LIBNOTIFY REQUIRED IMPORTED_TARGET "libnotify >= 0.7")
endif()

# Map ENABLE_DEBUG option to DEBUG define used in source code
if(ENABLE_DEBUG)
	set(DEBUG 1)
endif()

# Generate config.h
configure_file(config.h.cmake config.h)

# Subdirectories
add_subdirectory(src)
enable_testing()
add_subdirectory(test)
if(ENABLE_MANPAGES)
	add_subdirectory(doc)
endif()
