######################################################################
# Automatically generated by qmake (3.0) dom jan 24 22:51:13 2016
######################################################################
QT += core sql
TEMPLATE = lib
CONFIG += plugin
CONFIG += no_plugin_name_prefix

INCLUDEPATH += .
INCLUDEPATH += ../../../include
INCLUDEPATH += ../../../vendors/include

TARGET = OThread
DESTDIR = ../../../clib/

unix:LIBS  += ../../../shared/liboberon.so
win32:LIBS += ../../../shared/oberon.dll
win32:LIBS += ../../../vendors/lua51.dll

# Input
SOURCES += OThread.cpp
