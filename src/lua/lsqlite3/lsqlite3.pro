######################################################################
# Automatically generated by qmake (3.0) dom jan 24 22:51:13 2016
######################################################################
TEMPLATE = lib
CONFIG += plugin
CONFIG += no_plugin_name_prefix

INCLUDEPATH += .
INCLUDEPATH += ../../../include
INCLUDEPATH += ../../../vendors/include/luajit-2.0
INCLUDEPATH += ../../vendors/sqlite3/

TARGET = lsqlite3
DESTDIR = ../../../clib

LIBS += -L ../../../vendors -llua

# Input
SOURCES += lsqlite3.c ../../vendors/sqlite3/sqlite3.c
