# cmusfm - test/CMakeLists.txt
# SPDX-FileCopyrightText: 2015-2024 Arkadiusz Bokowy and contributors
# SPDX-License-Identifier: GPL-3.0-or-later

# Tests include .c source files directly, so they need the same
# include paths and compile definitions as the main binary.

function(cmusfm_add_test name)
	add_executable(${name} ${name}.c)
	target_compile_definitions(${name} PRIVATE HAVE_CONFIG_H=1)
	# Tests use assert() for both validation and side effects, so NDEBUG
	# must not be defined even in Release builds.
	target_compile_options(${name} PRIVATE -UNDEBUG)
	# Use CMAKE_CURRENT_BINARY_DIR (build/test/) so that #include "../config.h"
	# in included source files resolves to the generated config.h in the build root.
	target_include_directories(${name} PRIVATE
		${CMAKE_CURRENT_BINARY_DIR})
	add_test(NAME ${name} COMMAND ${name})
	set_tests_properties(${name} PROPERTIES TIMEOUT 300)
endfunction()

cmusfm_add_test(test-cache)
cmusfm_add_test(test-server-notify)
cmusfm_add_test(test-server-submit01)
cmusfm_add_test(test-server-submit02)

cmusfm_add_test(test-server-submit03)
target_link_libraries(test-server-submit03 PRIVATE pthread)

if(ENABLE_LIBNOTIFY)
	cmusfm_add_test(test-notify)
	target_link_libraries(test-notify PRIVATE PkgConfig::LIBNOTIFY)
endif()
