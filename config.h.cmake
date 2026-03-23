/* cmusfm - config.h.cmake
 * SPDX-FileCopyrightText: 2014-2024 Arkadiusz Bokowy and contributors
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#ifndef CMUSFM_CONFIG_H_CMAKE_
#define CMUSFM_CONFIG_H_CMAKE_

#define PACKAGE_STRING "@PROJECT_NAME@ @PROJECT_VERSION@"

#cmakedefine01 HAVE_SYS_INOTIFY_H

#cmakedefine01 ENABLE_LIBNOTIFY

#cmakedefine01 DEBUG

#endif
