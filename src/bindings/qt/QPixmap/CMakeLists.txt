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
  QPixmap SHARED QPixmap.cpp
)

find_package(Qt5Gui)

set_target_properties(QPixmap PROPERTIES PREFIX "")

target_link_libraries(QPixmap Qt5::Gui lua)
