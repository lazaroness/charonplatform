QT         += core
QT         += network
CONFIG     += console
CONFIG -= app_bundle

TEMPLATE    = app

TARGET      = miranda
DESTDIR     = ../../../bin

INCLUDEPATH += .
INCLUDEPATH += ../../../include
INCLUDEPATH += ../../../deps/include
INCLUDEPATH += ../../lua/json


QMAKE_RPATHDIR += ../deps

LIBS += -L ../../../deps -llua -lcharon -lcurl

# Input
SOURCES += main.cpp    \
    mirandacache.cpp   \
    mirandaserver.cpp  \
    mirandaservice.cpp \
    mirandastate.cpp   \
    mirandatask.cpp    \
    miranda_cache_register.cpp     \
    miranda_json_encode.c          \
    miranda_server_register.cpp    \
    miranda_service_register.cpp   \
    miranda_request_register.cpp   \
    miranda_task_register.cpp      \
    ../../lua/json/json_lock.cpp   \
    ../../lua/json/json.c   \
    ../../lua/json/strbuf.c \
    ../../lua/json/g_fmt.c  \
    ../../lua/json/dtoa.c

HEADERS += mirandaserver.h \
    mirandatask.h          \
    mirandastate.h         \
    ../../lua/json/json.h

mac:QMAKE_POST_LINK += install_name_tool -change libcharon.1.dylib  @executable_path/../deps/libcharon.1.dylib ../../../bin/miranda ; install_name_tool -change liblua.so  @executable_path/../deps/liblua.so ../../../bin/miranda
