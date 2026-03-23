# cmusfm - doc/CMakeLists.txt
# SPDX-FileCopyrightText: 2016-2024 Arkadiusz Bokowy and contributors
# SPDX-License-Identifier: GPL-3.0-or-later

find_program(RST2MAN NAMES rst2man rst2man.py)
if(NOT RST2MAN)
	message(FATAL_ERROR "--enable-manpages requires rst2man")
endif()

set(MAN_INPUT ${CMAKE_CURRENT_SOURCE_DIR}/cmusfm.1.rst)
set(MAN_OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/cmusfm.1)

add_custom_command(
	OUTPUT ${MAN_OUTPUT}
	COMMAND sed 's/\\$$VERSION\\$$/${PROJECT_NAME} ${PROJECT_VERSION}/' ${MAN_INPUT}
		| ${RST2MAN} - ${MAN_OUTPUT}
	DEPENDS ${MAN_INPUT}
	COMMENT "Generating man page cmusfm.1")

add_custom_target(manpages ALL DEPENDS ${MAN_OUTPUT})

install(FILES ${MAN_OUTPUT}
	DESTINATION ${CMAKE_INSTALL_MANDIR}/man1)
