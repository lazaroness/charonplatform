# ------------------------------------------------------------------------------
#
# Copyright 2016 The Charon Platform Authors.
#
# All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
#
# ------------------------------------------------------------------------------

include_directories(.)
include_directories(${PROJECT_SOURCE_DIR}/include)
include_directories(${PROJECT_SOURCE_DIR}/deps/include)

add_library(
  QFileInfo SHARED QFileInfo.cpp
)

find_package(Qt5Core)

set_target_properties(QFileInfo PROPERTIES PREFIX "")

target_link_libraries(QFileInfo Qt5::Core lua)
