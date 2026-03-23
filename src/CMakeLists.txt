# cmusfm - src/CMakeLists.txt
# SPDX-FileCopyrightText: 2014-2024 Arkadiusz Bokowy and contributors
# SPDX-License-Identifier: GPL-3.0-or-later

set(CMUSFM_SOURCES
	cache.c
	config.c
	libscrobbler2.c
	server.c
	utils.c
	main.c)

if(ENABLE_LIBNOTIFY)
	list(APPEND CMUSFM_SOURCES notify.c)
endif()

add_executable(cmusfm ${CMUSFM_SOURCES})

target_compile_definitions(cmusfm PRIVATE HAVE_CONFIG_H=1)

# Use CMAKE_CURRENT_BINARY_DIR (build/src/) so that #include "../config.h"
# in source files resolves to the generated config.h in the build root.
target_include_directories(cmusfm PRIVATE
	${CMAKE_CURRENT_BINARY_DIR})

target_link_libraries(cmusfm PRIVATE
	PkgConfig::LIBCURL)

if(ENABLE_LIBNOTIFY)
	target_link_libraries(cmusfm PRIVATE PkgConfig::LIBNOTIFY)
endif()

install(TARGETS cmusfm DESTINATION ${CMAKE_INSTALL_BINDIR})
