######################################################################
# Automatically generated by qmake (3.0) qua mar 30 16:32:25 2016
######################################################################

TEMPLATE = lib

CONFIG += plugin
CONFIG += no_plugin_name_prefix

DESTDIR = ../../../../clib/oberon
TARGET = helper

INCLUDEPATH += .
INCLUDEPATH += ../../../../include
INCLUDEPATH += ../../../../vendors/include

# Input
SOURCES += helper.cpp
SOURCES += os.cpp
SOURCES += string.cpp

unix:LIBS += -lcurl

unix:LIBS += ../../../../shared/liboberon.so
win32:LIBS += ../../../../shared/oberon.dll

win32:LIBS += ../../../../vendors/lua51.dll
win32:LIBS += ../../../../vendors/libcurl.dll
